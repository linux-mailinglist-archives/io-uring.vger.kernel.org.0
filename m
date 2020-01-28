Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5069514C3C0
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 00:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgA1XvW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 18:51:22 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34829 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgA1XvW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 18:51:22 -0500
Received: by mail-pj1-f65.google.com with SMTP id q39so1831217pjc.0
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 15:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bCBh+FLNRwpBLUE0KB8X2nUjYWZXylmikT6KvRL4sFs=;
        b=j6cTbdKiVNhkCNkChg4fObsldqbIvtenE1ZwQTcUiBl28dLckz16pQ/ZTgvFSUNUox
         /3HVJpexJiCKd5/VjBsYXKbbcOt3VFgK7ph5h4nuK6XVN3tejL5FV1NvRHrXrnlq6zcw
         tL+UcHkrQUYW8AOJAZEV8JqhcwToF/KbRQTv4CEQRsMduWAaoSAPKkbtsFFjyoelcQdR
         jkNNAjII5BQ7MlXS26OoyuD0WVcuvEhP/2TrXdVg0cpJ0NMCZSLguU74XZTxg2cpc+hw
         nO8ETWYxMgTpQ4G2hx5V64d6mJDAM7B8uLOXthixhyfi9vFh/mg5u3MTrmywa9WO7dn/
         G8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bCBh+FLNRwpBLUE0KB8X2nUjYWZXylmikT6KvRL4sFs=;
        b=GHlX0Seqz9CHIL/7Na0Jfpv3EPJTAtSWte3N1m3GhXcFBaVfDMjm3JuHArT/dId8E2
         yQ5DfuHbZ4LIah1JE4+8JnMVR4vep2RNWvcBUsYBlcnb/HMgtziGzEq0z3E7yOL12Wvs
         wA7f8CKSbONPRHb6Jp4hoUuj2bpoKLHSlUyFN8eD8S3E/JY4PsDNeq3syQNG2+7EOBjp
         Hm0RCJz613TyzwqsSDbMgTGWMEG2DKUu9IzrEHC+bzOlTJjrvZVb72zdjMCeicyE9jHd
         Mh/kW9kG7e/1pLyVRsw2ES+ZBd53RzgLJ0z0HreGXjOkQN5cn948c6vHW7WuxIXD76kB
         +D7A==
X-Gm-Message-State: APjAAAWiRBGH7diT/9SN8IzMP6Lhr1i1QkOrxOTg8tNInM0BUruK0edz
        pE7fDWfOLF3wsSnU5ySbsYICbw==
X-Google-Smtp-Source: APXvYqzUQXPOjn2od91JTnjpHSNtQkSWMRbTSu+9wO10kZ/X+Tdt3+GaaLIVba+vH5YL4T2uQnaOQQ==
X-Received: by 2002:a17:90a:d0c5:: with SMTP id y5mr7501783pjw.126.1580255481586;
        Tue, 28 Jan 2020 15:51:21 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id i4sm187005pgc.51.2020.01.28.15.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 15:51:21 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
Message-ID: <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
Date:   Tue, 28 Jan 2020 16:51:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/20 4:40 PM, Jens Axboe wrote:
> On 1/28/20 4:36 PM, Pavel Begunkov wrote:
>> On 28/01/2020 22:42, Jens Axboe wrote:
>>> I didn't like it becoming a bit too complicated, both in terms of
>>> implementation and use. And the fact that we'd have to jump through
>>> hoops to make this work for a full chain.
>>>
>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>> This makes it way easier to use. Same branch:
>>>
>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>>
>>> I'd feel much better with this variant for 5.6.
>>>
>>
>> Checked out ("don't use static creds/mm assignments")
>>
>> 1. do we miscount cred refs? We grab one in get_current_cred() for each async
>> request, but if (worker->creds != work->creds) it will never be put.
> 
> Yeah I think you're right, that needs a bit of fixing up.

I think this may have gotten fixed with the later addition posted today?
I'll double check. But for the newer stuff, we put it for both cases
when the request is freed.

>> 2. shouldn't worker->creds be named {old,saved,etc}_creds? It's set as
>>
>>     worker->creds = override_creds(work->creds);
>>
>> Where override_creds() returns previous creds. And if so, then the following
>> fast check looks strange:
>>
>>     worker->creds != work->creds
> 
> Don't care too much about the naming, but the logic does appear off.
> I'll take a look at both of these tonight, unless you beat me to it.

Testing this now, what a braino.

diff --git a/fs/io-wq.c b/fs/io-wq.c
index ee49e8852d39..8fbbadf04cc3 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -56,7 +56,8 @@ struct io_worker {
 
 	struct rcu_head rcu;
 	struct mm_struct *mm;
-	const struct cred *creds;
+	const struct cred *cur_creds;
+	const struct cred *saved_creds;
 	struct files_struct *restore_files;
 };
 
@@ -135,9 +136,9 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
 {
 	bool dropped_lock = false;
 
-	if (worker->creds) {
-		revert_creds(worker->creds);
-		worker->creds = NULL;
+	if (worker->saved_creds) {
+		revert_creds(worker->saved_creds);
+		worker->cur_creds = worker->saved_creds = NULL;
 	}
 
 	if (current->files != worker->restore_files) {
@@ -424,10 +425,11 @@ static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
 static void io_wq_switch_creds(struct io_worker *worker,
 			       struct io_wq_work *work)
 {
-	if (worker->creds)
-		revert_creds(worker->creds);
+	if (worker->saved_creds)
+		revert_creds(worker->saved_creds);
 
-	worker->creds = override_creds(work->creds);
+	worker->saved_creds = override_creds(work->creds);
+	worker->cur_creds = work->creds;
 }
 
 static void io_worker_handle_work(struct io_worker *worker)
@@ -480,7 +482,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		}
 		if (work->mm != worker->mm)
 			io_wq_switch_mm(worker, work);
-		if (worker->creds != work->creds)
+		if (worker->cur_creds != work->creds)
 			io_wq_switch_creds(worker, work);
 		/*
 		 * OK to set IO_WQ_WORK_CANCEL even for uncancellable work,

-- 
Jens Axboe

