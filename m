Return-Path: <io-uring+bounces-3477-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E589996959
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 13:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FD961C21AA1
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 11:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9818191F8E;
	Wed,  9 Oct 2024 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EIiZLmnG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F389D18B465;
	Wed,  9 Oct 2024 11:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728475035; cv=none; b=G5b/2CMsG32tWpPfaQaAsY6E2AYbhHLQAjI04Rv0TXkoW7zZ4iEBQX43+KMU2BT4SCF1scf+wjScF7HEcvvgYcbvvmUQcMxAWWhUKB1PymKTwDDF7HOZN4XY/5qf+ueQLpk/ynJhc9o4jU2m4Yi4At/xdsd20xQJAZjlcxaDyv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728475035; c=relaxed/simple;
	bh=BdI9hLY+neihDVo3VIfrpfbWIVEzempaZlYL3bk6BDc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fp+foTnE1vGwM3FhCrqBhYnQeGX04QCajhjvfmVtIh4KplKQaCYtpaj7u5YHJRS5e8PF6g815vciHochDQOxWVehR66OxZRN6H1H++Ueb4+lzDIbwQYVeubRBF6mxiUGTSOOQthgMAxgilXQJaNdzLrkuf3NIt4AhEvxmFIewMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EIiZLmnG; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a999521d0c3so60954766b.1;
        Wed, 09 Oct 2024 04:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728475032; x=1729079832; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/UUNqnihsrE1ATvgGxNIwPTeYGb0RCLPswUhDhs8ljA=;
        b=EIiZLmnGO1gSZWao+2+cOvgSB1drE6CSds34qYTt4WBvCHmPoQcCju0we21OIRxoXt
         8Ugqn4jjcetB+F369ahgN6oEFANqm+81grsIJF3B0BrntwQ+cf9QFg93ShAjbARVSY+j
         8JQZXxTbjAJxf2W55LF39yT1Z2LUyyJ0sWLwUbTJpOTwo/LchLQrJozVpIRw7j1A06mf
         REVoyZa7gighgBYKEWSvHqt2PDVhcEpsfYsP6rUpt2uMsBFhaXfkttAUb6cIgaciFTXB
         XAw0kdrCYDfKTxqffSFW6w61+49IntFWfEyXXSVs26OaAiqdnjzP8vaQMsuHehrxC/in
         bHXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728475032; x=1729079832;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/UUNqnihsrE1ATvgGxNIwPTeYGb0RCLPswUhDhs8ljA=;
        b=SpYuILx2QIDFNfmd/9Dsui4+g4G+5GW7pisp1lXWb+K4OVoslUhwZ0YqME2X5ABCHF
         /vn8ctVtiidQR4Sy0XyqTpG41KfsJHMutoYVPoOhB4QggaoeI/EQi5zsUD5zzowpXaBP
         juJzOlayloC3l6F3PLb8koC7hGlBEzrrYxOaC0DcWTGUdVVccDO2fsh0UCtcINq/ueVs
         DV2WMAkIR+M0cGCuXNwvId1P6QLW3B1NLdzyQoAltXX3sH3X+LtOnpRQ1yHN/JRBvsfO
         f7V97OF54FxgbN10U3HCKJ6aSI03MGQ47pV33mHaaKu+5TCigOnnKUUyR1yr2NoBp3yz
         1Oig==
X-Forwarded-Encrypted: i=1; AJvYcCVApS4ggKJ4v28w6JiqNTeeCDdl+4nekRcP+mE4y+bvyIdTL8dPF9yO0MrXRDqtoFtONWt1SpETzw==@vger.kernel.org, AJvYcCVwkH635DOefyp3NdNyjLUgmtfyUkL4vqfobcYGYPokWyPk/3oZrMuGBP5sHzqNTwUcknhzMCt3qreGC1w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYo+id+MEEs62r1kdHRw+z37pATyhrBLoSUGiqK+sWuytLd4Mq
	5CcAkOP25cmO+334Qhm/bG3sbPxdv8JbVUOq0c4RrXYxkJ96aMdj
X-Google-Smtp-Source: AGHT+IExGDGl/uDqcLTOoK4/+VtABIHIQ78/G42lMEGsvx5eMTyWzBwxuN+d0V9PGwKtS/VbDsdvdw==
X-Received: by 2002:a17:907:ea6:b0:a99:6791:5449 with SMTP id a640c23a62f3a-a998d32d74cmr203212766b.52.1728475032188;
        Wed, 09 Oct 2024 04:57:12 -0700 (PDT)
Received: from [192.168.42.45] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a993c1b353dsm589843866b.35.2024.10.09.04.57.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 04:57:11 -0700 (PDT)
Message-ID: <e3ae3aa0-3851-4d4e-9185-c04c84efaaaf@gmail.com>
Date: Wed, 9 Oct 2024 12:57:48 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 6/8] io_uring: support providing sqe group buffer
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-7-ming.lei@redhat.com>
 <51c10faa-ac28-4c40-82c4-373dbcad6e79@gmail.com> <ZwJcqS61eXM5pmor@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZwJcqS61eXM5pmor@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/6/24 10:47, Ming Lei wrote:
> On Fri, Oct 04, 2024 at 04:32:04PM +0100, Pavel Begunkov wrote:
>> On 9/12/24 11:49, Ming Lei wrote:
>> ...
> ...
>>> @@ -473,6 +494,7 @@ enum {
>>>    	REQ_F_BUFFERS_COMMIT_BIT,
>>>    	REQ_F_SQE_GROUP_LEADER_BIT,
>>>    	REQ_F_SQE_GROUP_DEP_BIT,
>>> +	REQ_F_GROUP_KBUF_BIT,
>>>    	/* not a real bit, just to check we're not overflowing the space */
>>>    	__REQ_F_LAST_BIT,
>>> @@ -557,6 +579,8 @@ enum {
>>>    	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
>>>    	/* sqe group with members depending on leader */
>>>    	REQ_F_SQE_GROUP_DEP	= IO_REQ_FLAG(REQ_F_SQE_GROUP_DEP_BIT),
>>> +	/* group lead provides kbuf for members, set for both lead and member */
>>> +	REQ_F_GROUP_KBUF	= IO_REQ_FLAG(REQ_F_GROUP_KBUF_BIT),
>>
>> We have a huge flag problem here. It's a 4th group flag, that gives
>> me an idea that it's overabused. We're adding state machines based on
>> them "set group, clear group, but if last set it again. And clear
>> group lead if refs are of particular value". And it's not really
>> clear what these two flags are here for or what they do.
>>
>>  From what I see you need here just one flag to mark requests
>> that provide a buffer, ala REQ_F_PROVIDING_KBUF. On the import
>> side:
>>
>> if ((req->flags & GROUP) && (req->lead->flags & REQ_F_PROVIDING_KBUF))
>> 	...
>>
>> And when you kill the request:
>>
>> if (req->flags & REQ_F_PROVIDING_KBUF)
>> 	io_group_kbuf_drop();
> 
> REQ_F_PROVIDING_KBUF may be killed too, and the check helper can become:
> 
> bool io_use_group_provided_buf(req)
> {
> 	return (req->flags & GROUP) && req->lead->grp_buf;
> }

->grp_kbuf is unionised, so for that to work you need to ensure that
only a buffer providing cmd / request could be a leader of a group,
which doesn't sound right.

-- 
Pavel Begunkov

