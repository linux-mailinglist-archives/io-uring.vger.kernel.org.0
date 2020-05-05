Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AAB1C5DF5
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2020 18:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgEEQxg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 May 2020 12:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729847AbgEEQxg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 May 2020 12:53:36 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D4FC061A0F
        for <io-uring@vger.kernel.org>; Tue,  5 May 2020 09:53:36 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x2so1676845ilp.13
        for <io-uring@vger.kernel.org>; Tue, 05 May 2020 09:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tinLj5erhK0fRZ5hsrYNJyDfko8um6uSZHUgTqb8+uM=;
        b=Okh6nMnqtW8p5ZSX3fheyHpt6JNpWyY1RmFejSTymP1xS75VIF2/YTrzxKRWRVt5e3
         7NHNxuSTBmH9EOFT8+qYMANOGmkLM5zUmOz1xDq2fFfjKj1CwNc9o3MdMxOJPn5jn8U0
         d+087nGL+qJdfOz88I/bg75iTOO/SpAmCsJppwara/vBZr5OmLQSVkqPc3o2eImdDpgA
         JzGAaD7wkYcGfQhe10bbPY58aIeyvkg9dDGLk7XfDfHmVvDo3F7ZN003pF2pqHJZV7nh
         qH8uCFKhWCLPrCRFK52dpA/0gAFaYDu5pXHULzoVWB8icdgSf/Bsz0xuUiwMwxDa5xvH
         K4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tinLj5erhK0fRZ5hsrYNJyDfko8um6uSZHUgTqb8+uM=;
        b=H5HbZMObBlD7/K5Ya0O5+Bpw6JiWUnmUKwGTO9ZaJVCFojWEPO8B2qVHp/DwD7jrz2
         X+Eipt+hzq4ZwxQiBPb8wFx6LsQLADQwWJarD85dRCW4jdO4hHDaAqx71LNgi3Oak+BD
         fyXANyIrNP9IzVLmV8mFiygajBF2LUkHwCUj/hSxSdzXuLp4ukb6kgGFh+ENS0vGh/6M
         nkHoJoTZWZWgQ/TNWZCRS0Lduz5aDR6EDiIlCdFaUrv6lg91mAMlb02tZCwDkiNypbk+
         C1GKqZH6QceJ+HDKQgoTJ6Vr7VTwHJuttDxGEXWU0ygvgQ/YB7k1qSlgpMAbxIQ6Oudq
         6S3A==
X-Gm-Message-State: AGi0PubGjjwEcSWaCTCmCYIEewiPzp7la40s4MrDGWd0DM+HwljLOuUC
        3Ax60rxXIFtwUjfiCCC4yyhabQ==
X-Google-Smtp-Source: APiQypLSfjKxuVuGrSQ7Lf8Sr62S+mrdOp8YoW2h2Zj6eUcwKuEmACvLk/4ru8SI3XaDQwLQZdwIqA==
X-Received: by 2002:a05:6e02:544:: with SMTP id i4mr4659551ils.145.1588697615469;
        Tue, 05 May 2020 09:53:35 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s5sm2026639ili.59.2020.05.05.09.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 09:53:34 -0700 (PDT)
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        Jeremy Allison <jra@samba.org>
References: <0009f6b7-9139-35c7-c0b1-b29df2a67f70@samba.org>
 <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
 <7ed7267d-a0ae-72ac-2106-2476773f544f@kernel.dk>
Message-ID: <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
Date:   Tue, 5 May 2020 10:53:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <7ed7267d-a0ae-72ac-2106-2476773f544f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/20 9:44 AM, Jens Axboe wrote:
> On 5/5/20 8:41 AM, Jens Axboe wrote:
>> On 5/5/20 4:04 AM, Stefan Metzmacher wrote:
>>> Hi Jens,
>>>
>>> we currently have a bug report [1][2] regarding a data corruption with
>>> Samba's vfs_io_uring.c [3].
>>>
>>> Is there're a know problem in newer kernels? It seems the 5.3 Kernel
>>> doesn't have the problem (at least Jeremy wasn't able to reproduce it
>>> on the Ubuntu 5.3 kernel).
>>>
>>> Do you have any hints how to track that down?
>>
>> I'll take a look at this! Any chance Jeremy can try 5.4 and 5.5 as well,
>> just to see where we're at, roughly? That might be very helpful.
> 
> Trying to setup samba in a vm here to attempt to reproduce. I'm a major
> samba noob, running with the smb.conf from the reporters email, I get:
> 
> [2020/05/05 15:43:07.126674,  0] ../../source4/smbd/server.c:629(binary_smbd_main)
>   samba version 4.12.2 started.
>   Copyright Andrew Tridgell and the Samba Team 1992-2020
> [2020/05/05 15:43:07.152828,  0] ../../source4/smbd/server.c:826(binary_smbd_main)
>   At this time the 'samba' binary should only be used for either:
>   'server role = active directory domain controller' or to access the ntvfs file server with 'server services = +smb' or the rpc proxy with 'dcerpc endpoint servers = remote'
>   You should start smbd/nmbd/winbindd instead for domain member and standalone file server tasks
> [2020/05/05 15:43:07.152937,  0] ../../lib/util/become_daemon.c:121(exit_daemon)
>   exit_daemon: daemon failed to start: Samba detected misconfigured 'server role' and exited. Check logs for details, error code 22
> 
> Clue bat appreciated.

Got it working, but apparently the arch samba doesn't come with io_uring...
One question, though, from looking at the source:

static ssize_t vfs_io_uring_pread_recv(struct tevent_req *req,
				  struct vfs_aio_state *vfs_aio_state)
{
[...]
	if (state->ur.cqe.res < 0) {
		vfs_aio_state->error = -state->ur.cqe.res;
		ret = -1;
	} else {
		vfs_aio_state->error = 0;
		ret = state->ur.cqe.res;
	}

	tevent_req_received(req);
[...]

I'm assuming this is dealing with short reads?

I'll try and see if I can get an arch binary build that has the
vfs_io_uring module and reproduce.
	
-- 
Jens Axboe

