Return-Path: <io-uring+bounces-245-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F13E8806420
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 02:29:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB531282241
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 01:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D334FEBF;
	Wed,  6 Dec 2023 01:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y7o10oEp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD3A109
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 17:29:06 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-54d048550dfso1970655a12.0
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 17:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701826145; x=1702430945; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RrNjUJQUINcCFXTO9rDL8Ky5tKqmH83BD7yI/W6Ixq4=;
        b=Y7o10oEpsiQ79Xbp09lH4+WjVDSyaTZ6Btop37X/FseHOOFb8pxYdBaR2rCVTJXQMd
         sU9nKOlHGBbewWcowtt5oY6X190QHgSefBYEClCIU/4uiLdddFxHOGq402xYfrOpxfCe
         QHEDkmwbucjK+hF44EeKBEjk5IrpZGnXQBbt00vXYBW4bLXXsWarKBh7n57m77ba2RvF
         ggHLHsrdfLvWeSDiq5tZR+fDbMJsEbHXnzaPBzy5+P9jmtTZi1NXtdv66c0Scv/M1IFc
         M7hDFmJ9+y4hk3K33I1OlQP6IZ3EUChjQezZSuiS6e9bKrP3QTIHFpUxltORhpH5ks9P
         QcGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701826145; x=1702430945;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RrNjUJQUINcCFXTO9rDL8Ky5tKqmH83BD7yI/W6Ixq4=;
        b=oJ2QRUhdYr/N4vnvLfB0CfJZIHw4USLus6XoHGbvPtDl8GjykVVgWUrIh0TlSLLfQD
         0q/cLvqtwEUp9kefWlGMBw7F/PIYrIJGhQBuEQ8Ha393yB0IClUCdpaMx8LV95X3+pJ1
         FB02EkUpOFYy2W2Y1w4yKrg0d3HYJa47KO1DzadunQSXKc04igzbHepQceoLHkMyGl/f
         cMm3YBV/8ZSZn5gnIzY1+2SL2nZsbl6stoj9eqKAC0sV7662+uhwTZE+sZqYnjUYWbdS
         ERb3gmP1werXim3ZuZE2YUkPkzUnOJDkE8itOp0Os0LfIcqDAKleFBGNQljKwE/bJ2R3
         nTng==
X-Gm-Message-State: AOJu0YxtURM1kdBZAM95+P8aqDwNvwDVz0+/WOCpblWGI9SnIowpKGiW
	Ei/D4riA8OSwsJa5geMgc3A=
X-Google-Smtp-Source: AGHT+IF51kDTBzxgGrfc3qve/UXmvbGAeWwuXPQpnlvzdbltoKq9mj2tr8Kg1vzS4FjIEMWLrMuJVw==
X-Received: by 2002:a50:c181:0:b0:54c:4837:7d37 with SMTP id m1-20020a50c181000000b0054c48377d37mr76990edf.118.1701826144878;
        Tue, 05 Dec 2023 17:29:04 -0800 (PST)
Received: from [192.168.8.100] ([148.252.140.209])
        by smtp.gmail.com with ESMTPSA id b20-20020aa7cd14000000b0054c8f7708c9sm1739425edw.79.2023.12.05.17.29.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 17:29:04 -0800 (PST)
Message-ID: <db385b87-d954-4147-a3b3-614b428c5a1e@gmail.com>
Date: Wed, 6 Dec 2023 01:26:29 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: save repeated issue_flags
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@meta.com>,
 io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <20231205215553.2954630-1-kbusch@meta.com>
 <43ff7474-5174-4738-88d9-9c43517ae235@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <43ff7474-5174-4738-88d9-9c43517ae235@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/23 22:00, Jens Axboe wrote:
> On 12/5/23 2:55 PM, Keith Busch wrote:
>> From: Keith Busch <kbusch@kernel.org>
>>
>> No need to rebuild the issue_flags on every IO: they're always the same.
>>
>> Suggested-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Keith Busch <kbusch@kernel.org>
>> ---
[...]
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index 8a38b9f75d841..dbc0bfbfd0f05 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -158,19 +158,13 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>   	if (ret)
>>   		return ret;
>>   
>> -	if (ctx->flags & IORING_SETUP_SQE128)
>> -		issue_flags |= IO_URING_F_SQE128;
>> -	if (ctx->flags & IORING_SETUP_CQE32)
>> -		issue_flags |= IO_URING_F_CQE32;
>> -	if (ctx->compat)
>> -		issue_flags |= IO_URING_F_COMPAT;
>>   	if (ctx->flags & IORING_SETUP_IOPOLL) {
>>   		if (!file->f_op->uring_cmd_iopoll)
>>   			return -EOPNOTSUPP;
>> -		issue_flags |= IO_URING_F_IOPOLL;
>>   		req->iopoll_completed = 0;
>>   	}
>>   
>> +	issue_flags |= ctx->issue_flags;
>>   	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>>   	if (ret == -EAGAIN) {
>>   		if (!req_has_async_data(req)) {
> 
> I obviously like this idea, but it should be accompanied by getting rid
> of ->compat and ->syscall_iopoll in the ctx as well?

This all piggy backing cmd specific bits onto core io_uring issue_flags
business is pretty nasty. Apart from that, it mixes constant io_uring
flags and "execution context" issue_flags. And we're dancing around it
not really addressing the problem.

IMHO, cmds should be testing for IORING_SETUP flags directly via
helpers, not renaming them and abusing core io_uring flags. E.g. I had
a patch like below but didn't care enough to send:


diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 909377068a87..1a82a0633f16 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2874,7 +2874,7 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
  
  	ublk_ctrl_cmd_dump(cmd);
  
-	if (!(issue_flags & IO_URING_F_SQE128))
+	if (!(io_uring_cmd_get_ctx_flags(cmd) & IORING_SETUP_SQE128))
  		goto out;
  
  	ret = ublk_check_cmd_op(cmd_op);
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index d69b4038aa3e..8a18a705ff31 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -79,4 +79,11 @@ static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd
  	return cmd_to_io_kiocb(cmd)->task;
  }
  
+static inline unsigned io_uring_cmd_get_ctx_flags(struct io_uring_cmd *cmd)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+
+	return ctx->flags;
+}
+
  #endif /* _LINUX_IO_URING_CMD_H */

-- 
Pavel Begunkov

