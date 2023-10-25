Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65A37D6D89
	for <lists+io-uring@lfdr.de>; Wed, 25 Oct 2023 15:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbjJYNoi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Oct 2023 09:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbjJYNoh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Oct 2023 09:44:37 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5AB132
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 06:44:35 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-7748ca56133so40019239f.0
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 06:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698241474; x=1698846274; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wjb6WfHKRCLzWXISsTapoloapEDY6fe4aw3miOCALJ8=;
        b=b2y9egUKmsQQMkUWZfsmyo1lWgrX9zfgEHlu7+bbGdfHb6bgWtYa5FGZFtkB8EsLRP
         OQWzn8jiel4MyLxX6dDXFKEncbEWE0HKhV4LOA4DA64FmX61G5ajWK+0zvQHcGXggPl1
         B87Um7Qf1oj7Uq0tykzp2x73SpUEhj37PazhRgvKrdOF7fM3cm6QsUJsg6G0nkadq4Qw
         FFFwYoFBpJZoBKXBF4A9KkrbVVL4jXBnHW8z3sYpxJiiyg/TgJ8zNJ+upglO/YCrW4LX
         zFN4u3i5sjfh8oYy2pf8zU+rjnrKVINuzTH3GHrPoxH0N1BMs+jTu6exAD2hBbmVw7qb
         bNiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698241474; x=1698846274;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wjb6WfHKRCLzWXISsTapoloapEDY6fe4aw3miOCALJ8=;
        b=fF+DCQBZbb3FkrvSboQNBuNTlFE3My0v2D0qcbpFAFfG0kJjrGyhxvJdPuRONHIjhN
         tYYHmbqT6QArBCOYvxMJUEw+b0i86ADHqxD2liP5ebleDejGhM/8sSAk8O5vLeFk6+O7
         S6uA2gTliIi1H0lVvlVhy0XQuYvtlsjbjnGKuBXEOyIDePdU/e/gU7jDk/YOgpw/T42u
         NtcRqz9ix6/hipBNgocZqPfD2CvP48dVG8Boboz/JyLNceBtjB4B9s14Os2Bn6SUeuYr
         2Wi6lVcJL8S7UjVtxYIhL46a2GXvVK8TmiDmft3dOsr+fvly5/3uOqAcoLRTd3Hv236I
         1aXA==
X-Gm-Message-State: AOJu0Yw4aXKOgpsVq5aQBYCv9ecFxoAoqhsVyHTyRE03H+lQxO+Da1ko
        P8DzUQ+QSNihUERWbDSltO7uqIj1dxdmrIAn3R2qAA==
X-Google-Smtp-Source: AGHT+IFhOCTlnA9NzLtt6iS5x9AR6wiH25viw7KqWQpvxHJzWjooJcqflISl49F1xsbdR53daBZntg==
X-Received: by 2002:a5e:dd01:0:b0:7a6:a005:4984 with SMTP id t1-20020a5edd01000000b007a6a0054984mr13688167iop.1.1698241474514;
        Wed, 25 Oct 2023 06:44:34 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y14-20020a056602120e00b0078647b08ab0sm3690759iot.6.2023.10.25.06.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 06:44:33 -0700 (PDT)
Message-ID: <de2c75e1-8f0a-4dfe-81f2-fa2637096c6d@kernel.dk>
Date:   Wed, 25 Oct 2023 07:44:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/fdinfo: park SQ thread while retrieving cpu/pid
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <64f28d0f-b2b9-4ff4-8e2f-efdf1c63d3d4@kernel.dk>
 <65368e95.170a0220.4fb79.0929SMTPIN_ADDED_BROKEN@mx.google.com>
 <23557993-424d-42a8-b832-2e59f164a577@kernel.dk>
 <103b6f05-831c-e875-478a-7e9f8187575e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <103b6f05-831c-e875-478a-7e9f8187575e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/25/23 6:09 AM, Pavel Begunkov wrote:
> On 10/23/23 16:27, Jens Axboe wrote:
>> On 10/23/23 9:17 AM, Gabriel Krisman Bertazi wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>> We could race with SQ thread exit, and if we do, we'll hit a NULL pointer
>>>> dereference. Park the SQPOLL thread while getting the task cpu and pid for
>>>> fdinfo, this ensures we have a stable view of it.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=218032
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> ---
>>>>
>>>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>>>> index c53678875416..cd2a0c6b97c4 100644
>>>> --- a/io_uring/fdinfo.c
>>>> +++ b/io_uring/fdinfo.c
>>>> @@ -53,7 +53,6 @@ static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
>>>>   __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>>   {
>>>>       struct io_ring_ctx *ctx = f->private_data;
>>>> -    struct io_sq_data *sq = NULL;
>>>>       struct io_overflow_cqe *ocqe;
>>>>       struct io_rings *r = ctx->rings;
>>>>       unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
>>>> @@ -64,6 +63,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>>       unsigned int cq_shift = 0;
>>>>       unsigned int sq_shift = 0;
>>>>       unsigned int sq_entries, cq_entries;
>>>> +    int sq_pid = -1, sq_cpu = -1;
>>>>       bool has_lock;
>>>>       unsigned int i;
>>>>   @@ -143,13 +143,18 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>>       has_lock = mutex_trylock(&ctx->uring_lock);
>>>>         if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
>>>> -        sq = ctx->sq_data;
>>>> -        if (!sq->thread)
>>>> -            sq = NULL;
>>>> +        struct io_sq_data *sq = ctx->sq_data;
>>>> +
>>>> +        io_sq_thread_park(sq);
>>>> +        if (sq->thread) {
>>>> +            sq_pid = task_pid_nr(sq->thread);
>>>> +            sq_cpu = task_cpu(sq->thread);
>>>> +        }
>>>> +        io_sq_thread_unpark(sq);
>>>
>>> Jens,
>>>
>>> io_sq_thread_park will try to wake the sqpoll, which is, at least,
>>> unnecessary. But I'm thinking we don't want to expose the ability to
>>> schedule the sqpoll from procfs, which can be done by any unrelated
>>> process.
>>>
>>> To solve the bug, it should be enough to synchronize directly on
>>> sqd->lock, preventing sq->thread from going away inside the if leg.
>>> Granted, it is might take longer if the sqpoll is busy, but reading
>>> fdinfo is not supposed to be fast.  Alternatively, don't call
>>> wake_process in this case?
>>
>> I did think about that but just went with the exported API. But you are
>> right, it's a bit annoying that it'd also wake the thread, in case it
> 
> Waking it up is not a problem but without parking sq thread won't drop
> the lock until it's time to sleep, which might be pretty long leaving
> the /proc read stuck on the lock uninterruptibly.
> 
> Aside from parking vs lock, there is a lock inversion now:
> 
> proc read                   | SQPOLL
>                             |
> try_lock(ring) // success   |
>                             | woken up
>                             | lock(sqd); // success
> lock(sqd); // stuck         |
>                             | try to submit requests
>                             | -- lock(ring); // stuck

Yeah good point, forgot we nest these opposite of what you'd expect.
Honestly I think the fix here is just to turn it into a trylock. Yes
that'll miss some cases where we could've gotten the pid/cpu, but
doesn't seem worth caring about.

IOW, fold in this incremental.

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index af1bdcc0703e..f04a43044d91 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -145,12 +145,13 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
 		struct io_sq_data *sq = ctx->sq_data;
 
-		mutex_lock(&sq->lock);
-		if (sq->thread) {
-			sq_pid = task_pid_nr(sq->thread);
-			sq_cpu = task_cpu(sq->thread);
+		if (mutex_trylock(&sq->lock)) {
+			if (sq->thread) {
+				sq_pid = task_pid_nr(sq->thread);
+				sq_cpu = task_cpu(sq->thread);
+			}
+			mutex_unlock(&sq->lock);
 		}
-		mutex_unlock(&sq->lock);
 	}
 
 	seq_printf(m, "SqThread:\t%d\n", sq_pid);

-- 
Jens Axboe

