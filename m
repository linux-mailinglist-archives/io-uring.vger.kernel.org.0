Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00DF7D3AB5
	for <lists+io-uring@lfdr.de>; Mon, 23 Oct 2023 17:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjJWP12 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Oct 2023 11:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjJWP12 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Oct 2023 11:27:28 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B652F93
        for <io-uring@vger.kernel.org>; Mon, 23 Oct 2023 08:27:25 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-357ac7cd08aso1661205ab.1
        for <io-uring@vger.kernel.org>; Mon, 23 Oct 2023 08:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698074844; x=1698679644; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lnIQRUL3dGnj78SSGpA9SkpL9VRUsEUy0PKD+EZ4u14=;
        b=fRPLw784klrgNo+yJm0F79vW0+K12b3ak+jR+u6MUyUwUJ4dIE3al37qao/uRpoaLb
         YoWRQsNBSMeq0dOokfTva8ntc9guUFWCbHC+oerNUy8Ssq+ykDH8IUXCl1si+2inih3k
         LFsKFqwMpo7Ar/5Xz3mF1GXA2HtGgVQPCgcdWmSJxlwqkRGazYtaFmHuhEbB2P9yBpY2
         BjQ4YpoO7HPAYbaie2rb5mMnem8IlSP9bY0AxfX/S2pcGHUm48bgvfut4FExPyo+2TwP
         7ZHZbGryqwlGBNQa9S4UgzmpXlg+9KRXHTgDEJ3wwQRCxFMepb2xVzpsC0erkNjPObic
         qNlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698074844; x=1698679644;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lnIQRUL3dGnj78SSGpA9SkpL9VRUsEUy0PKD+EZ4u14=;
        b=EJ0bU5Xy25uizT9kGDud4s2sGZSeROos1l+Gg/dVK6rVR8G2E+3mrCvTDoPFUtiFZy
         BtEmm4ggI4orEtyGzeSJuEqjhcZsz5W9jTJlBg1N0RG6iVOsg6nKj+1dYtvvLSvWeM8c
         6A1L3sD7wRj6K4WeL5qIuzzr+V/Q8DAoHwc+gzCyN6l3Kgb3uP3fCtWCSk2usWdgr9Pc
         oRGScmDMG+X48u/zIhcCpBftKkEyaCT4iTNie/+Sgpc4BVF8jxBZASv5s3MkiWrfWZXZ
         /VQHu0UPX5xzUhaPVngJ5j8Mj90HalaYwML50ozOzwX+iSNuwOHJzH6VQetM6GSmGuXV
         SLVA==
X-Gm-Message-State: AOJu0YysIPXWzAeGQDUatRF1LVSivxvDg6LDYjmncGq8u0bNHG/8opBq
        Cfuw/On6ZM4vWcZgJb28QsvaRuf5d848r2htX4WmRQ==
X-Google-Smtp-Source: AGHT+IHvr2iAoVJtdU092UjQ74GYONc3W8v56fp+AHyZeSGUTguky9jWJzG4wufO8gUtKku+fXVhxg==
X-Received: by 2002:a5e:a502:0:b0:79f:8cd3:fd0e with SMTP id 2-20020a5ea502000000b0079f8cd3fd0emr9015388iog.1.1698074844161;
        Mon, 23 Oct 2023 08:27:24 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id do38-20020a0566384ca600b0044d10eda3a8sm2272545jab.158.2023.10.23.08.27.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 08:27:23 -0700 (PDT)
Message-ID: <23557993-424d-42a8-b832-2e59f164a577@kernel.dk>
Date:   Mon, 23 Oct 2023 09:27:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/fdinfo: park SQ thread while retrieving cpu/pid
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <64f28d0f-b2b9-4ff4-8e2f-efdf1c63d3d4@kernel.dk>
 <65368e95.170a0220.4fb79.0929SMTPIN_ADDED_BROKEN@mx.google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <65368e95.170a0220.4fb79.0929SMTPIN_ADDED_BROKEN@mx.google.com>
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

On 10/23/23 9:17 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> We could race with SQ thread exit, and if we do, we'll hit a NULL pointer
>> dereference. Park the SQPOLL thread while getting the task cpu and pid for
>> fdinfo, this ensures we have a stable view of it.
>>
>> Cc: stable@vger.kernel.org
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=218032
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>> index c53678875416..cd2a0c6b97c4 100644
>> --- a/io_uring/fdinfo.c
>> +++ b/io_uring/fdinfo.c
>> @@ -53,7 +53,6 @@ static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
>>  __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>  {
>>  	struct io_ring_ctx *ctx = f->private_data;
>> -	struct io_sq_data *sq = NULL;
>>  	struct io_overflow_cqe *ocqe;
>>  	struct io_rings *r = ctx->rings;
>>  	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
>> @@ -64,6 +63,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>  	unsigned int cq_shift = 0;
>>  	unsigned int sq_shift = 0;
>>  	unsigned int sq_entries, cq_entries;
>> +	int sq_pid = -1, sq_cpu = -1;
>>  	bool has_lock;
>>  	unsigned int i;
>>  
>> @@ -143,13 +143,18 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>  	has_lock = mutex_trylock(&ctx->uring_lock);
>>  
>>  	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
>> -		sq = ctx->sq_data;
>> -		if (!sq->thread)
>> -			sq = NULL;
>> +		struct io_sq_data *sq = ctx->sq_data;
>> +
>> +		io_sq_thread_park(sq);
>> +		if (sq->thread) {
>> +			sq_pid = task_pid_nr(sq->thread);
>> +			sq_cpu = task_cpu(sq->thread);
>> +		}
>> +		io_sq_thread_unpark(sq);
> 
> Jens,
> 
> io_sq_thread_park will try to wake the sqpoll, which is, at least,
> unnecessary. But I'm thinking we don't want to expose the ability to
> schedule the sqpoll from procfs, which can be done by any unrelated
> process.
> 
> To solve the bug, it should be enough to synchronize directly on
> sqd->lock, preventing sq->thread from going away inside the if leg.
> Granted, it is might take longer if the sqpoll is busy, but reading
> fdinfo is not supposed to be fast.  Alternatively, don't call
> wake_process in this case?

I did think about that but just went with the exported API. But you are
right, it's a bit annoying that it'd also wake the thread, in case it
was idle. Probably mostly cosmetic, but we may as well just stick with
grabbing the sqd mutex. I'll send a v2.

-- 
Jens Axboe

