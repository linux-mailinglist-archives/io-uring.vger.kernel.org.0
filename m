Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C871E91C9
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 15:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgE3Nn5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 09:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgE3Nn4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 09:43:56 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9EEC03E969
        for <io-uring@vger.kernel.org>; Sat, 30 May 2020 06:43:55 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t7so451141pgt.3
        for <io-uring@vger.kernel.org>; Sat, 30 May 2020 06:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YUloyRCVnYQLL6OoYK9di+1m5Rh2FgDtF4wKaDh2E38=;
        b=SdV2n+ntC3SYn10YfTwHK0VdofCGT/agzEmDK0MBRB8R6191/DJAc/aox6cqW666j1
         CsYHsFMFfZiXHZ3TSpfIdEwMnCuo8SP+zGHtDf8+ERLNdsYzuUSRwDdqShRN/OeAXK96
         DzgbbW5QWAikXrHV4lo9TxawbfOY02wPdHcRmMQyJvZ/p9EG7XpZerSMdDsPQzJOOQPP
         OHhXTstJH/Gzku0530nbBvMYjOBY4++qr1ND8s3QtR8JGJIM2Mwd6p5zH1Vtl2nAJgb6
         e9OemPD4W6yFEwLP9It+eAxn5o0+PePulbgEQ8JPPA044Tg0UgNiEcC0m0GVBl5qnywN
         RgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YUloyRCVnYQLL6OoYK9di+1m5Rh2FgDtF4wKaDh2E38=;
        b=NyKScfW/NIlIQtT6uia9roXbAh2Z/Swdkn+G9K4FUagcUY5p2ixEIDdtlZc6fMvUUZ
         grycn1tJ2+QPxFVQGtkYW6cqYIoHvwSDXyMgpXa+Qyw4K6nXDgFjalJi/QqFg6ZU2e44
         xmWYtzcARLg3LbJ/eEZjJUkb4eNv9L5qCxX7fkJvxlY2uwLGjEm/HhVm13Q8SarNXGWM
         BvFvS5S193F8Avh1E2i53w4ZZm0J6O4W97d6ZfWoET5C6sxhuXD6KlzoaV/Ugy3TwUTK
         wkBIKaFLxotT/GKBgD8YJKrP8gLflyZs6u+MbysMWdP6V3I7rx/CquGxEz/A7ODqwcAV
         dbKw==
X-Gm-Message-State: AOAM533gQ6NapLfC0y99gsTDjjjDy3Cz00kiURdBDgucoLcXEBZSgTh5
        qJv2wvKPG6GSGXROoi9aFUhhWE4kYAUBCg==
X-Google-Smtp-Source: ABdhPJx3sjzVI0HKf93YryqXnF39WfmiiCndPVXhEtOYYyr4O9HnisDIAanN65YBzkSNw7zmrNKXNg==
X-Received: by 2002:a65:5645:: with SMTP id m5mr12100772pgs.434.1590846234970;
        Sat, 30 May 2020 06:43:54 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x2sm3394203pff.103.2020.05.30.06.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 06:43:54 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200528091550.3169-1-xiaoguang.wang@linux.alibaba.com>
 <fa5b8034-c911-3de1-cfec-0b3a82ae701a@gmail.com>
 <b472d985-0e34-c53a-e976-3a174211d12b@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <09f99ed6-5e08-4040-8445-466b276fe925@kernel.dk>
Date:   Sat, 30 May 2020 07:43:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b472d985-0e34-c53a-e976-3a174211d12b@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/20 7:36 AM, Xiaoguang Wang wrote:
> hi,
> 
>> On 28/05/2020 12:15, Xiaoguang Wang wrote:
>>> If requests can be submitted and completed inline, we don't need to
>>> initialize whole io_wq_work in io_init_req(), which is an expensive
>>> operation, add a new 'REQ_F_WORK_INITIALIZED' to control whether
>>> io_wq_work is initialized.
>>
>> It looks nicer. Especially if you'd add a helper as Jens supposed.
> Sure, I'll add a helper in V4, thanks.
> 
>>
>> The other thing, even though I hate treating a part of the fields differently
>> from others, I don't like ->creds tossing either.
>>
>> Did you consider trying using only ->work.creds without adding req->creds? like
>> in the untested incremental below. init_io_work() there is misleading, should be
>> somehow played around better.
> But if not adding a new req->creds, I think there will be some potential risks.
> In current io_uring mainline codes, look at io_kiocb's memory layout
> crash> struct -o io_kiocb
> struct io_kiocb {
>          union {
>      [0]     struct file *file;
>      [0]     struct io_rw rw;
>      [0]     struct io_poll_iocb poll;
>      [0]     struct io_accept accept;
>      [0]     struct io_sync sync;
>      [0]     struct io_cancel cancel;
>      [0]     struct io_timeout timeout;
>      [0]     struct io_connect connect;
>      [0]     struct io_sr_msg sr_msg;
>      [0]     struct io_open open;
>      [0]     struct io_close close;
>      [0]     struct io_files_update files_update;
>      [0]     struct io_fadvise fadvise;
>      [0]     struct io_madvise madvise;
>      [0]     struct io_epoll epoll;
>      [0]     struct io_splice splice;
>      [0]     struct io_provide_buf pbuf;
>          };
>     [64] struct io_async_ctx *io;
>     [72] int cflags;
>     [76] u8 opcode;
>     [78] u16 buf_index;
>     [80] struct io_ring_ctx *ctx;
>     [88] struct list_head list;
>    [104] unsigned int flags;
>    [108] refcount_t refs;
>    [112] struct task_struct *task;
>    [120] unsigned long fsize;
>    [128] u64 user_data;
>    [136] u32 result;
>    [140] u32 sequence;
>    [144] struct list_head link_list;
>    [160] struct list_head inflight_entry;
>    [176] struct percpu_ref *fixed_file_refs;
>          union {
>              struct {
>    [184]         struct callback_head task_work;
>    [200]         struct hlist_node hash_node;
>    [216]         struct async_poll *apoll;
>              };
>    [184]     struct io_wq_work work;
>          };
> }
> SIZE: 240
> 
> struct io_wq_work {
>     [0] struct io_wq_work_node list;
>     [8] void (*func)(struct io_wq_work **);
>    [16] struct files_struct *files;
>    [24] struct mm_struct *mm;
>    [32] const struct cred *creds;
>    [40] struct fs_struct *fs;
>    [48] unsigned int flags;
>    [52] pid_t task_pid;
> }
> SIZE: 56
> 
> The risk mainly comes from the union:
> union {
> 	/*
> 	 * Only commands that never go async can use the below fields,
> 	 * obviously. Right now only IORING_OP_POLL_ADD uses them, and
> 	 * async armed poll handlers for regular commands. The latter
> 	 * restore the work, if needed.
> 	 */
> 	struct {
> 		struct callback_head	task_work;
> 		struct hlist_node	hash_node;
> 		struct async_poll	*apoll;
> 	};
> 	struct io_wq_work	work;
> };
> 
> 1, apoll and creds are in same memory offset, for 'async armed poll handlers' case,
> apoll will be used, that means creds will be overwrited. In patch "io_uring: avoid
> unnecessary io_wq_work copy for fast poll feature", I use REQ_F_WORK_INITIALIZED
> to control whether to do io_wq_work restore, then your below codes will break:
> 
> static inline void io_req_work_drop_env(struct io_kiocb *req)
> {
> 	/* always init'ed, put before REQ_F_WORK_INITIALIZED check */
> 	if (req->work.creds) {
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Here req->work.creds will be invalid, or I still need to use some space
> to record original req->work.creds, and do creds restore.
> 
> 		put_cred(req->work.creds);
> 		req->work.creds = NULL;
> 	}
> 	if (!(req->flags & REQ_F_WORK_INITIALIZED))
>   		return;
> 
> 2, For IORING_OP_POLL_ADD case, current mainline codes will use task_work and hash_node,
> 32 bytes, that means io_wq_work's member list, func, files and mm would be overwrited,
> but will not touch creds, it's safe now. But if we will add some new member to
> struct {
> 	struct callback_head	task_work;
> 	struct hlist_node	hash_node;
> 	struct async_poll	*apoll;
> };
> say callback_head adds a new member, our check will still break.
> 
> 3. IMO, io_wq_work is just to describe needed running environment for reqs that will be
> punted to io-wq, for reqs submitted and completed inline should not touch this struct
> from software design view, and current io_kiocb is 240 bytes, and a new pointer will be
> 248 bytes, still 4 cache lines for cache line 64 bytes.

I'd say let's do the extra creds member for now. It's safer. We can always look into
shrinking down the size and re-using the io_wq_work part. I'd rather get this
prepped up and ready for 5.8.

Are you sending out a v4 today?

-- 
Jens Axboe

