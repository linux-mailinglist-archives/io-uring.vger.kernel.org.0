Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB9B323A1F
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 11:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhBXKEe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Feb 2021 05:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbhBXKEC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Feb 2021 05:04:02 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAAAC06174A
        for <io-uring@vger.kernel.org>; Wed, 24 Feb 2021 02:03:22 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id b3so1280213wrj.5
        for <io-uring@vger.kernel.org>; Wed, 24 Feb 2021 02:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z+vmL4ffec/IYrQ1uIrc/0zHKK+pvP94PMd/SIdSvFk=;
        b=Xjy6FKIPGpRjuNFM/oUWCmq1ntBFjqAGQ+u68deeLQsEA2QDbD+3CLIF2/ty74+jKA
         FPbjeJghePqhm1F47psd+cuFU9V4KXlqEv9SaQTZIbIujGKOuu9jrj7vhLrxjIXHNb6Z
         SpX1pco3kPubXB7sn/azsRijNoIkvaB7MknKVgQumZKgLL/0xkPN49mGcN3WS+UNf8nO
         VzCkuTwrY3C8px7hw62WjfYAlysoQGNOBFNWH6l988Aogg0gif4yNrvy1n9XIe/ah2jQ
         Gg7xOY7kDcF3b8W0Z4f2IqT2SqzDO61OMBpJj2d7tlcWOw3wVT6peoZAeKY1qkzDiTdp
         Q+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=z+vmL4ffec/IYrQ1uIrc/0zHKK+pvP94PMd/SIdSvFk=;
        b=CWogAkGRE6yxeFcpIGmQR7DTbl9GIUJdrqDfSE4T1/wEOWI7dODIz77NRa7XsRVoIo
         5aPipY/aWd3erEPcWBMn+xfu3sA7NU5uHhzc8naiB8gdj1DjwR3QdxIk9/HA+Tx9tAI9
         jvI0KwhIGah8RI7Zb4+vmYbj12vYowNd8n3W5C+qEmmttKdwCQIeSE5uDLjbh3X/9NMV
         a/Dvg6d4Vy3akskHQRnWlRJOM/syT2CnjMwiNL1nbIOYhlT6cGlYBSb2Wd8QC00Oa9gd
         /b0rsLrSlru6BNI1ZXh2zZxJDwFULvy6OrMoyRQZlxJRVLD1qlVKsXXI4Pefx+G/0MmN
         wjcA==
X-Gm-Message-State: AOAM530i7s6olBU6CpgOCsaP1HMnq1J0W5IQDgT6WYydeLYFgz73txdq
        dsgLMOqVmSedTiBd/Yg+/6o=
X-Google-Smtp-Source: ABdhPJxQHZTdeFsyn1/3n9B1nUw37bhORihoKrkFPhWhIkWLep23cUiMLZJoQtcFra3VQsOzPdETSQ==
X-Received: by 2002:adf:f292:: with SMTP id k18mr5300219wro.335.1614161001277;
        Wed, 24 Feb 2021 02:03:21 -0800 (PST)
Received: from [192.168.8.165] ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id o124sm1878345wmo.41.2021.02.24.02.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 02:03:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20210206150006.1945-1-xiaoguang.wang@linux.alibaba.com>
 <e4220bf0-2d60-cdd8-c738-cf48236073fa@gmail.com>
 <3e3cb8da-d925-7ebd-11a0-f9e145861962@linux.alibaba.com>
 <f3081423-bdee-e7e4-e292-aa001f0937d1@gmail.com>
 <e185a388-9b7c-b01f-bcf9-2440d9024fd2@gmail.com>
 <754563ed-5b2b-075d-16f8-d980e51102e6@linux.alibaba.com>
 <215e12a6-1aa7-c56f-1349-bd3828b225f6@kernel.dk>
 <7f52ca3a-b456-582e-c3db-99d2d028042f@linux.alibaba.com>
 <6a09434b-f975-cc49-cc6a-a5d369be325b@kernel.dk>
 <d1bad7d9-aea4-5dfa-52a5-1c72ce29470f@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: don't issue reqs in iopoll mode when ctx is
 dying
Message-ID: <1c3b911c-1013-4fe1-12e3-1a650b0e207f@gmail.com>
Date:   Wed, 24 Feb 2021 09:59:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d1bad7d9-aea4-5dfa-52a5-1c72ce29470f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24/02/2021 09:46, Pavel Begunkov wrote:
>> Are you sure? We just don't want to reissue it, we need to fail it.
>> Hence if we catch it at reissue time, that should be enough. But I'm
>> open to clue batting :-)
> 
> Jens, IOPOLL can happen from a different task, so
> 1) we don't want to grab io_wq_work context from it. As always we can pass it
> through task_work, or should be solved with your io-wq patches.
> 
> 2) it happens who knows when in time, so iovec may be gone already -- same
> reasoning why io_[read,write]() copy it before going to io-wq.

The diff below should solve the second problem by failing them (not tested).
1) can be left to the io-wq patches.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf9ad810c621..561c29b20463 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2610,8 +2610,11 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		list_del(&req->inflight_entry);
 
 		if (READ_ONCE(req->result) == -EAGAIN) {
+			bool reissue = req->async_data ||
+				!io_op_defs[req->opcode].needs_async_data;
+
 			req->iopoll_completed = 0;
-			if (io_rw_reissue(req))
+			if (reissue && io_rw_reissue(req))
 				continue;
 		}
 


-- 
Pavel Begunkov
