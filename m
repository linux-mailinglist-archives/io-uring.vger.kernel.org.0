Return-Path: <io-uring+bounces-40-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 211E87E2B86
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 18:57:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4C41B210BD
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 17:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 186D12C854;
	Mon,  6 Nov 2023 17:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gV8KRCib"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84AE2C851
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 17:57:02 +0000 (UTC)
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF4C1BF
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 09:57:01 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-7748ca56133so43659739f.0
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 09:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699293420; x=1699898220; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+6OjqiR6YtQIHxyG152RocnqxBXMCAZfd8sOwXSTqgE=;
        b=gV8KRCibtQ5kV3dhYtbbS4FJ09hK6vvtSJXhVAW0XUkD6quWW0NyBSxXYWsbYVsD3k
         PCTSX2ZKrM/wuS0nXFsbxoxB4p08KA1ZXanJ2vWLbMur1+GGruYg9BRdSMla1nmDoius
         sWR2kQKff8vt8eVvzfvCIsitgUO7pcm+suDF28mDBQB0IS/AaBa2w9KxySDYnBZxEsnt
         RHHJ9KcyNPFLHcPjppDnUZDY5qtTaY3ah24tvJgqQdc4N/opW4WJEz8AI9exEf+7MVFg
         STPdg8yTWZFrF8Cp4MiaLsb3O0p1s3k3v5o4OJ5/Cdzl728x9J15AnD6BuuVi6sBOy++
         Bhog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699293420; x=1699898220;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+6OjqiR6YtQIHxyG152RocnqxBXMCAZfd8sOwXSTqgE=;
        b=CFlEJMMZd4TZZgMpeNPBfGI0dAwBBzxIEk6wXOYVjUFHe+GGgKSM06FEquXCFYHt8u
         e8buPN9/eiJxxofZ8/gwmXuTGzHV71O+/9f1gbhzIUdRxKy7tNaA65ufLjJa33M9Z19z
         5O038JePngI0c18do/KPMTmYyQgsfN/6yyREX6zfF170xPIszCS5aXl+Ks2uBRQIGdSm
         unVOxR91XQIZ0qOmBPegCtPk8BNS41urLa5E/bxPl7vFjSOOXCAYWgz+ew48fSg+vFQ4
         o6Yx2OjT+LxSONzGuoYWBf4OKgr2rjeSlbbeib3Al93N+borC9y/tx0Ee7JGEJUKdnE0
         gD2Q==
X-Gm-Message-State: AOJu0YxDlHjqx+4rqginlER2XnUTf3F17zQqXKcBYbNSPU4wuf6PtAzg
	lLE79rlGTEBqHlGLo0PYMCVIfw==
X-Google-Smtp-Source: AGHT+IFM7kzU9rZmxU15OOI+/ApAW0SQ4+1JFCPgJQfzzBCDkoxjf+k4DpsGkqZtWVqq2fzyLhaDFQ==
X-Received: by 2002:a6b:f00b:0:b0:7a9:6f8f:b5ed with SMTP id w11-20020a6bf00b000000b007a96f8fb5edmr29043948ioc.2.1699293420336;
        Mon, 06 Nov 2023 09:57:00 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id fj38-20020a056638636600b00464001012c7sm1537202jab.129.2023.11.06.09.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 09:56:59 -0800 (PST)
Message-ID: <def86bcd-f601-4533-b744-040cddd760b8@kernel.dk>
Date: Mon, 6 Nov 2023 10:56:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: do not clamp read length for multishot read
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Dylan Yudaken <dyudaken@gmail.com>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
References: <20231105223008.125563-1-dyudaken@gmail.com>
 <20231105223008.125563-3-dyudaken@gmail.com>
 <b6db6eeb-3940-43ab-8cae-fb81ff109e41@kernel.dk>
 <CAO_Yeogr9D+MH2m4GGq40mKHfyvVgUscdPsjh2STi0Y2TZGNBQ@mail.gmail.com>
 <249f2e9f-12c2-4a1a-9b90-4b38ee8db3a5@kernel.dk>
In-Reply-To: <249f2e9f-12c2-4a1a-9b90-4b38ee8db3a5@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/23 8:46 AM, Jens Axboe wrote:
> On 11/6/23 8:33 AM, Dylan Yudaken wrote:
>> On Mon, Nov 6, 2023 at 2:46?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 11/5/23 3:30 PM, Dylan Yudaken wrote:
>>>> When doing a multishot read, the code path reuses the old read
>>>> paths. However this breaks an assumption built into those paths,
>>>> namely that struct io_rw::len is available for reuse by __io_import_iovec.
>>>>
>>>> For multishot this results in len being set for the first receive
>>>> call, and then subsequent calls are clamped to that buffer length incorrectly.
>>>
>>> Should we just reset this to 0 always in io_read_mshot()? And preferably
>>> with a comment added as well as to why that is necessary to avoid
>>> repeated clamping.
>>
>> Unfortunately I don't think (without testing) that will work.
>> Sometimes the request
>> comes into io_read_mshot with the buffer already selected, and the
>> length cannot
>> be touched in that case.
>>
>> We could check if the buffer is set, and if not clear the length I guess.
>> I'm a bit unsure which is better - both seem equally ugly to be honest.
> 
> I mean do it at the end when we complete it, so it's reset for the next
> iteration. But yeah, I'd want to have the test case verify this first
> :-)

Something ala the below?

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 9e3e56b74e35..9121832eadec 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -932,6 +932,12 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	 * Any successful return value will keep the multishot read armed.
 	 */
 	if (ret > 0) {
+		/*
+		 * Reset rw->len to 0 again to avoid clamping future mshot
+		 * reads, in case the buffer size varies.
+		 */
+		io_kiocb_to_cmd(req, struct io_rw)->len = 0;
+
 		/*
 		 * Put our buffer and post a CQE. If we fail to post a CQE, then
 		 * jump to the termination path. This request is then done.

-- 
Jens Axboe


