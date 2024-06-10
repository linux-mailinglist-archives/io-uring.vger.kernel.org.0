Return-Path: <io-uring+bounces-2145-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53CD0901946
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 03:55:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDDC0281B7E
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 01:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DE02A29;
	Mon, 10 Jun 2024 01:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jFlhcatb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70113C0B;
	Mon, 10 Jun 2024 01:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717984526; cv=none; b=O+yVi5kv2eSshPX1T/KA5v9Uqd1LO1hMsMVmqI6FAf5Db46y4XNm+Os7SrCpFJrAHifSKRO0FdRtGlK3pEChsY/4QFUUE6/F5kQbjVEdGtqSwfGym3W71tGBc/Mra12QjdKtaFD+34j1IQPA9nWDxGttOdr5lrTbZ468/3gaP98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717984526; c=relaxed/simple;
	bh=0JnLAUYQC4gvXm9kjQ2/dA/n300m/JSchKQU8k/7YZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uIKMcyOVAP+LculewG6YfqMGCy8l0U32ISAO+159uNYljyEMk1IhuymcJezBsr6WQ/1R0Jgq9nl4kICNrLYZM1lF0v3ToHkdIrx6Bh6tclBtvswjPliqyIiMQ5FlMCPB6nXFaJiznlvTySxtFeztlD33yEMspIekza4yJD840OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jFlhcatb; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4217136a74dso17453415e9.2;
        Sun, 09 Jun 2024 18:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717984523; x=1718589323; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CCs6SVF+SM0LxwNRkFpCiwEF4cEjtDRTqEee1kjVu4E=;
        b=jFlhcatbVwCjdYuYsnUyFAsllbVHEkNE1lI1H8tKtLUjLlFtWkTM8mphpOudGXmXHn
         isxUu1ap0VE/DzCDYeGxT39nOCZtDlZJ6FP9lZyS9WrfIVPQOVj4oeF2OjkLnOOfzngE
         rMS68FBXR0b3TMJ6l51bl57V9ZXIVIJXLrNaFh8zDfwXt9AHVV/njuVSi+CjeSgvtmnc
         oHowbpkdYyfHVWFWqUJQSP7PL6oUT7LwMlmfezVkibO27E433iC0v1TpmvLQF41+8Yd2
         JADpxlh+ne3hXSW7SNk1BTz8K9RtGGFmLQSj4dK+y2Tu03heq3Yc4PLt+L68xOjOpbqI
         N8Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717984523; x=1718589323;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CCs6SVF+SM0LxwNRkFpCiwEF4cEjtDRTqEee1kjVu4E=;
        b=DvnavgyziGRM2mKPSf7clCtewl3TVvDsS5GXQDMwmSycV4pZOUPwYFoLrqsTCOU2n0
         KrRMH2qYybce2lI8aOMwksfoWlHQ4IybkpuxS59jramvU54dNJOskH/KeVDUVQKhONEC
         gFYBZI+5ewzvtQ4OocXMJgkMt7hKI7hqaO4RT4qJOit8ZixbOexyUhOEkFgzodTVoIPv
         OnxJdSs5pjecmk1jF+kGTRYVnqH2c9YmwXNbRq1DlA4dbT6Q3L50y5U7NGBP9QisCREz
         cIDROb4u/KTR+fp0ucrfVyXeBHgYbKaSpHdupnVV+LER0YvmY5S8jCk9KxI52JAgXdiD
         AEwA==
X-Forwarded-Encrypted: i=1; AJvYcCVw2hyVYiuYbz0HlhL+oxEUL8pnNIAO+gx7aFxNkWnqzvusmyZoEs2/SJaVUHAcDM+CTwAYk7nXLJTYq9Fn0l8oCTGM9BGSzpA=
X-Gm-Message-State: AOJu0YyQ9YRXRcuHmGVozJSofKn8IPr3uTfni0zeoLXMg9S1o6hVgxhx
	9353saIScptczxAwPfgcvpfhx21MS1RcarJa9F2PEUlWX+C9veKi
X-Google-Smtp-Source: AGHT+IFwvrUjU1WsLPgyieyn8SimD9ocCOemkTtfwUTdT7XkaViw/TvOck3ke9FDEeFaYa40V/DcFA==
X-Received: by 2002:a05:600c:35c6:b0:421:7f4d:5240 with SMTP id 5b1f17b1804b1-4217f4d56bemr26777695e9.24.1717984522974;
        Sun, 09 Jun 2024 18:55:22 -0700 (PDT)
Received: from [192.168.42.136] ([148.252.129.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42182ed2b23sm32970175e9.18.2024.06.09.18.55.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jun 2024 18:55:22 -0700 (PDT)
Message-ID: <3fd4451f-d30e-43f8-a01f-428a1073882d@gmail.com>
Date: Mon, 10 Jun 2024 02:55:22 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 5/9] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-6-ming.lei@redhat.com> <ZkwNxxUM7jqzpqgg@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZkwNxxUM7jqzpqgg@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/21/24 03:58, Ming Lei wrote:
> On Sat, May 11, 2024 at 08:12:08AM +0800, Ming Lei wrote:
>> SQE group is defined as one chain of SQEs starting with the first SQE that
>> has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
>> doesn't have it set, and it is similar with chain of linked SQEs.
>>
>> Not like linked SQEs, each sqe is issued after the previous one is completed.
>> All SQEs in one group are submitted in parallel, so there isn't any dependency
>> among SQEs in one group.
>>
>> The 1st SQE is group leader, and the other SQEs are group member. The whole
>> group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
>> the two flags are ignored for group members.
>>
>> When the group is in one link chain, this group isn't submitted until the
>> previous SQE or group is completed. And the following SQE or group can't
>> be started if this group isn't completed. Failure from any group member will
>> fail the group leader, then the link chain can be terminated.
>>
>> When IOSQE_IO_DRAIN is set for group leader, all requests in this group and
>> previous requests submitted are drained. Given IOSQE_IO_DRAIN can be set for
>> group leader only, we respect IO_DRAIN by always completing group leader as
>> the last one in the group.
>>
>> Working together with IOSQE_IO_LINK, SQE group provides flexible way to
>> support N:M dependency, such as:
>>
>> - group A is chained with group B together
>> - group A has N SQEs
>> - group B has M SQEs
>>
>> then M SQEs in group B depend on N SQEs in group A.
>>
>> N:M dependency can support some interesting use cases in efficient way:
>>
>> 1) read from multiple files, then write the read data into single file
>>
>> 2) read from single file, and write the read data into multiple files
>>
>> 3) write same data into multiple files, and read data from multiple files and
>> compare if correct data is written
>>
>> Also IOSQE_SQE_GROUP takes the last bit in sqe->flags, but we still can
>> extend sqe->flags with one uring context flag, such as use __pad3 for
>> non-uring_cmd OPs and part of uring_cmd_flags for uring_cmd OP.
>>
>> Suggested-by: Kevin Wolf <kwolf@redhat.com>
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> 
> BTW, I wrote one link-grp-cp.c liburing/example which is based on sqe group,
> and keep QD not changed, just re-organize IOs in the following ways:
> 
> - each group have 4 READ IOs, linked by one single write IO for writing
>    the read data in sqe group to destination file

IIUC it's comparing 1 large write request with 4 small, and
it's not exactly anything close to fair. And you can do same
in userspace (without links). And having control in userspace
you can do more fun tricks, like interleaving writes for one
batch with reads from the next batch.


> - the 1st 12 groups have (4 + 1) IOs, and the last group have (3 + 1)
>    IOs
> 
> 
> Run the example for copying two block device(from virtio-blk to
> virtio-scsi in my test VM):
> 
> 1) buffered copy:
> - perf is improved by 5%
> 
> 2) direct IO mode
> - perf is improved by 27%
> 
> 
> [1] link-grp-cp.c example
> 
> https://github.com/ming1/liburing/commits/sqe_group_v2/
> 
> 
> [2] one bug fixes(top commit) against V3
> 
> https://github.com/ming1/linux/commits/io_uring_sqe_group_v3/
> 
> 
> 
> Thanks,
> Ming
> 

-- 
Pavel Begunkov

