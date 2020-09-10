Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33491263E1E
	for <lists+io-uring@lfdr.de>; Thu, 10 Sep 2020 09:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgIJHKa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Sep 2020 03:10:30 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:44613 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730279AbgIJHIH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Sep 2020 03:08:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U8UD1Vi_1599721683;
Received: from 30.225.32.137(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U8UD1Vi_1599721683)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Sep 2020 15:08:04 +0800
Subject: Re: [FIO PATCH] engines/io_uring: add sqthread_poll_percpu option
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com
References: <20200910070524.14740-1-xiaoguang.wang@linux.alibaba.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <eac7a778-4015-182d-df9d-964c3258d52b@linux.alibaba.com>
Date:   Thu, 10 Sep 2020 15:07:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200910070524.14740-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

You can use this patch to test IORING_SETUP_SQPOLL_PERCPU flag introduced in
patch " io_uring: support multiple rings to share same poll thread by specifying same cpu".
Below is a example fio job:
[global]
ioengine=io_uring
sqthread_poll=1
sqthread_poll_percpu=1
registerfiles=1
fixedbufs=1
hipri=0
thread=1
bs=4k
direct=1
rw=randread
time_based=1
runtime=60
randrepeat=0
filename=/dev/vdb

[job1]
cpus_allowed=2
sqthread_poll_cpu=17
iodepth=128

[job2]
cpus_allowed=3
sqthread_poll_cpu=17
iodepth=128

[job3]
cpus_allowed=4
sqthread_poll_cpu=17
iodepth=128

[job4]
cpus_allowed=5
sqthread_poll_cpu=17
iodepth=128

Regards,
Xiaoguang Wang

> This option is only meaningful when sqthread_poll and sqthread_poll_cpu
> are both set. If this option is effective, for multiple io_uring instances
> which are all bound to one same cpu, only a kernel thread is created for
> this cpu to perform these io_uring instances' submission queue polling.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>   engines/io_uring.c  | 13 +++++++++++++
>   fio.1               |  6 ++++++
>   os/linux/io_uring.h |  1 +
>   3 files changed, 20 insertions(+)
> 
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index ec8cb18a..8a447b62 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -77,6 +77,7 @@ struct ioring_options {
>   	unsigned int fixedbufs;
>   	unsigned int registerfiles;
>   	unsigned int sqpoll_thread;
> +	unsigned int sqpoll_thread_percpu;
>   	unsigned int sqpoll_set;
>   	unsigned int sqpoll_cpu;
>   	unsigned int nonvectored;
> @@ -160,6 +161,16 @@ static struct fio_option options[] = {
>   		.category = FIO_OPT_C_ENGINE,
>   		.group	= FIO_OPT_G_IOURING,
>   	},
> +	{
> +		.name	= "sqthread_poll_percpu",
> +		.lname	= "Kernel percpu SQ thread polling",
> +		.type	= FIO_OPT_INT,
> +		.off1	= offsetof(struct ioring_options, sqpoll_thread_percpu),
> +		.help	= "Offload submission/completion to kernel thread, use percpu thread",
> +		.category = FIO_OPT_C_ENGINE,
> +		.group	= FIO_OPT_G_IOURING,
> +	},
> +
>   	{
>   		.name	= "sqthread_poll_cpu",
>   		.lname	= "SQ Thread Poll CPU",
> @@ -596,6 +607,8 @@ static int fio_ioring_queue_init(struct thread_data *td)
>   		p.flags |= IORING_SETUP_IOPOLL;
>   	if (o->sqpoll_thread) {
>   		p.flags |= IORING_SETUP_SQPOLL;
> +		if (o->sqpoll_thread_percpu)
> +			p.flags |= IORING_SETUP_SQPOLL_PERCPU;
>   		if (o->sqpoll_set) {
>   			p.flags |= IORING_SETUP_SQ_AFF;
>   			p.sq_thread_cpu = o->sqpoll_cpu;
> diff --git a/fio.1 b/fio.1
> index 1c90e4a5..d367134f 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -1851,6 +1851,12 @@ the cost of using more CPU in the system.
>   When `sqthread_poll` is set, this option provides a way to define which CPU
>   should be used for the polling thread.
>   .TP
> +.BI (io_uring)sqthread_poll_percpu
> +This option is only meaningful when `sqthread_poll` and `sqthread_poll_cpu` are
> +both set. If this option is effective, for multiple io_uring instances which are all
> +bound to one same cpu, only a kernel thread is created for this cpu to perform these
> +io_uring instances' submission queue polling.
> +.TP
>   .BI (libaio)userspace_reap
>   Normally, with the libaio engine in use, fio will use the
>   \fBio_getevents\fR\|(3) system call to reap newly returned events. With
> diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
> index d39b45fd..0a4c8a35 100644
> --- a/os/linux/io_uring.h
> +++ b/os/linux/io_uring.h
> @@ -99,6 +99,7 @@ enum {
>   #define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
>   #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
>   #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
> +#define IORING_SETUP_SQPOLL_PERCPU (1U << 7)       /* sq_thread_cpu is valid */
>   
>   enum {
>   	IORING_OP_NOP,
> 
