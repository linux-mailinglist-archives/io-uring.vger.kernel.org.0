Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E934E659B
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 15:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349415AbiCXOsP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 10:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349476AbiCXOrx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 10:47:53 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAC7AC91D
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 07:46:20 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id x4so5598794iop.7
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 07:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=e4I8eBLCNqV0mMYJEdZ7DMc5CRK/htOueL0/zWeJtpA=;
        b=LlnwVytWaoE8hq6imzWOv7sFAgmQV10O4KWFqZZl5oKAZXkFJpHHa6nGIJ7B1Tsnc0
         m4XI5cEnZ8cMUwC1fETJImvLllXJ6WvykNGYLFa/Busu/2yED3TvuPiIl0u4LYHGvi4m
         9s4inok3F1l6Onk8sc7WovYloZ76YaWUZMJ15rDHgxpT7Ig3ZOGacBKXT5hh8lpclMmr
         w56PivlKAMWXypOPDXDJfqOMhUcw1PswWb3BBWrbbfNWcKow/JwQ96cdJJC2/FzR2fFZ
         pnPUH/QDKPTezp8jUf07BG23VFCNU5YPP8oXTXrE7h5RxPxgpILsOi+dC6Bd29opi2sU
         K7Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=e4I8eBLCNqV0mMYJEdZ7DMc5CRK/htOueL0/zWeJtpA=;
        b=0rVhRsSYj9rswHHymamiCvcwu6i1EK4kTe5xB+1dzi87cuxDvquQmTqi4yqFOOKSiZ
         sdG24RneT01YxpMKblMyixZWBQgLNBAJQzd6aImGZojvtmXqvP17Sl78b9ApaZBUfkI0
         XId2Q4N7z3RpUgJB4HDnlMCa//JRclSHa3DWNwTnrV8ubuynZEmDI9q0EDp6/Hw7Jhds
         bN2kp0iq3IumCCs83tKmzdZXIXncnXtpYxo5riak230JV5gSMuSmLOt0NjIm2qoHt9zm
         AoiteIUQN9HA1ipJXqFOUvnq8ZAdK/K/onN6XQF1h5B2xvTT4zgxn0qbCBNXLma7ds04
         sCvA==
X-Gm-Message-State: AOAM533Dqm4iOJUl4i7TkJZMStttKbiHvUOGt5my4H4d7FVdtvwNw90V
        SUkCkLVYpUxmijeN8ctbp8rJeQ==
X-Google-Smtp-Source: ABdhPJzw5l/5T+EBAGhbvxFfDI7hml9GXs/0Oz/dzif68nHSpgLM9BSd4ACEcUArwkTqVdEClGUqAQ==
X-Received: by 2002:a05:6638:4506:b0:321:410c:d998 with SMTP id bs6-20020a056638450600b00321410cd998mr3242107jab.85.1648133180092;
        Thu, 24 Mar 2022 07:46:20 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k10-20020a056e0205aa00b002c8266e72e8sm1529364ils.62.2022.03.24.07.46.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 07:46:19 -0700 (PDT)
Message-ID: <4ec0e6e4-6c44-56a3-ef9e-5536f61eea86@kernel.dk>
Date:   Thu, 24 Mar 2022 08:46:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] io_uring: allow async accept on O_NONBLOCK sockets
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-team@fb.com
References: <20220324143435.2875844-1-dylany@fb.com>
 <a545c1ae-02a7-e7f1-5199-5cd67a52bb1e@kernel.dk>
In-Reply-To: <a545c1ae-02a7-e7f1-5199-5cd67a52bb1e@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/24/22 8:42 AM, Jens Axboe wrote:
> On 3/24/22 8:34 AM, Dylan Yudaken wrote:
>> Do not set REQ_F_NOWAIT if the socket is non blocking. When enabled this
>> causes the accept to immediately post a CQE with EAGAIN, which means you
>> cannot perform an accept SQE on a NONBLOCK socket asynchronously.
>>
>> By removing the flag if there is no pending accept then poll is armed as
>> usual and when a connection comes in the CQE is posted.
>>
>> note: If multiple accepts are queued up, then when a single connection
>> comes in they all complete, one with the connection, and the remaining
>> with EAGAIN. This could be improved in the future but will require a lot
>> of io_uring changes.
> 
> Not true - all you'd need to do is have behavior similar to
> EPOLLEXCLUSIVE, which we already support for separate poll. Could be
> done for internal poll quite easily, and _probably_ makes sense to do by
> default for most cases in fact.

Quick wire-up below. Not tested at all, but really should basically as
simple as this.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4d98cc820a5c..8dfacb476726 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -967,6 +967,7 @@ struct io_op_def {
 	/* set if opcode supports polled "wait" */
 	unsigned		pollin : 1;
 	unsigned		pollout : 1;
+	unsigned		poll_exclusive : 1;
 	/* op supports buffer selection */
 	unsigned		buffer_select : 1;
 	/* do prep async if is going to be punted */
@@ -1061,6 +1062,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
+		.poll_exclusive		= 1,
 	},
 	[IORING_OP_ASYNC_CANCEL] = {
 		.audit_skip		= 1,
@@ -6293,6 +6295,8 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	} else {
 		mask |= POLLOUT | POLLWRNORM;
 	}
+	if (def->poll_exclusive)
+		mask |= EPOLLEXCLUSIVE;
 
 	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
 	    !list_empty(&ctx->apoll_cache)) {

-- 
Jens Axboe

