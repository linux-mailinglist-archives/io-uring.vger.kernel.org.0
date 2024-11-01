Return-Path: <io-uring+bounces-4309-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6D49B93EC
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 16:04:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0ED01C20FAD
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 15:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48F819F131;
	Fri,  1 Nov 2024 15:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="m4fxjE2m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8117113B7A1
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 15:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730473446; cv=none; b=JQz/Wp+pI0GjXxZBpPliVu4nFAprm2UlHEgNYGcjBWjQ0ZzAmbz8vX12Ue+DLyTBw3t3RW+Ynp+db2FQo7Bd28pmDt/LOZbbJNZkj4+lvqjYFNUuJYehAB1r5QWpsXlDlPfGtmrWYJfWNE+CdSTClybPzLklJsfpcRVZ2iYSjHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730473446; c=relaxed/simple;
	bh=Z+e5JkRPQ50eE5NtBceEEFgMM1GgxD7tDkPEWfsPaQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QAnVgAumXAiViydpp6upyZ1hrFu1i7BdXEuiL9RZwqXGGObUuQoB6RHClD+eDbybmxGwWxmGBrh7jirUc8Z1pvbY0/4Dye2ViRNUgUaGdNuG5Y5J2ecCoADxFAqDLBJo6AOealpSvXDular9Bemj1GLuoaplUvAtduOIB+ETrU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=m4fxjE2m; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2e3d523a24dso1664108a91.0
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 08:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730473443; x=1731078243; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u3IoX+E0zWl/XZrUlN3xGTz7Uhc/iscGIr8w6tjpRBE=;
        b=m4fxjE2mZGgeNfZ2tn3TFANoIpBL4AuqAUBNAra9KzQzmjETPEQq0GYLp8X9a+Tj5C
         LnxjJKZuF6U9jimm5Q4/LpUf8rKLvKVItNAL2TL8AfJQUCiE9tn3HrNSZRRFlHF157YP
         eXDh+TQlFk6TVW1fBycdf8wqF/sznVUuzfpJZVJKFwvdSEspxLIldgUbZv9VgZgF+kth
         KBX3/WzGOkf3wtqpafh0xHoytwxJpEaP+EaemvYGY3ddnI8pNvUz2dGD08YBPphI1mNZ
         n8hj0gBmZSCBCCSJn7bGy8n1/uEetNsgA/Ts0x/4peHOF92L5jPUVluRZDsnxKLwuapM
         h31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730473443; x=1731078243;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u3IoX+E0zWl/XZrUlN3xGTz7Uhc/iscGIr8w6tjpRBE=;
        b=WXTyW/HXyxZ8OseHzcBArQK0qgNxyLDaZIvdnyvPgbffBaTpdxj9lkvSJX+FVYH3oj
         BdJm5G0Ug0Oou293HbCarwD9BL+6KsJlnRPObfuwaHxFP85QC6s7jyOqaI6dCpcKW3ls
         TR95MqcqsZryaSmhT12T7pvlsYYkSGrJ6n8jTnCulaw/mRTQfC/paNYpIrNFbzptIyFL
         y1eX/3Anc15dshLQRdjGsJORnVx63yjramoYvxayraeUkjbRDDT9RebakHYqwkQuI3Qt
         d1jgcBROjn5l5DL7faSadkmIpG1C2La2hfz00eTqNgrgLFksza918v0sXaJmZSDn3gOX
         IfJA==
X-Gm-Message-State: AOJu0YykvGrYlq/6zspX4peVo/l65hzog8WFIlv9x1qCg+zvnj8yxtGM
	X7OqVBwjgC6WUFIhu04R4b+f/65jlZMp92F1laVXZxiffzolc5X5wLZjlxTZcCw=
X-Google-Smtp-Source: AGHT+IEnklCmfE8ZtWQZFRev705Y5a8RZoFfUhNV+r+n3klnMsHYuKmjqjnjHZaSIPzDKj7i9izIKA==
X-Received: by 2002:a17:90a:b111:b0:2e2:d16e:8769 with SMTP id 98e67ed59e1d1-2e8f106926emr24705789a91.15.1730473442650;
        Fri, 01 Nov 2024 08:04:02 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e93db46b71sm2776679a91.57.2024.11.01.08.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 08:04:02 -0700 (PDT)
Message-ID: <8f7c42ab-d395-4864-a052-f078dee6c0a6@kernel.dk>
Date: Fri, 1 Nov 2024 09:04:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] io_uring: extend io_uring_sqe flags bits
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring <io-uring@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>
References: <e60a3dd3-3a74-4181-8430-90c106a202f6@kernel.dk>
 <ZyQ5CcwfLhaASvMz@fedora> <ZyRAKm0IQV7wWjhC@fedora>
 <3a907323-331f-4442-a2a0-4e2757aaba8b@kernel.dk> <ZyTm9rBQpy7WFdwK@fedora>
 <e648e765-9076-4236-a75d-c7baf68c1040@kernel.dk> <ZyTtMJBRJuqsdeBV@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZyTtMJBRJuqsdeBV@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/1/24 9:01 AM, Ming Lei wrote:
> On Fri, Nov 01, 2024 at 08:42:42AM -0600, Jens Axboe wrote:
>> On 11/1/24 8:34 AM, Ming Lei wrote:
>>> On Fri, Nov 01, 2024 at 07:59:38AM -0600, Jens Axboe wrote:
>>>> On 10/31/24 8:42 PM, Ming Lei wrote:
>>>>> On Fri, Nov 01, 2024 at 10:12:25AM +0800, Ming Lei wrote:
>>>>>> On Thu, Oct 31, 2024 at 03:22:18PM -0600, Jens Axboe wrote:
>>>>>>> In hindsight everything is clearer, but it probably should've been known
>>>>>>> that 8 bits of ->flags would run out sooner than later. Rather than
>>>>>>> gobble up the last bit for a random use case, add a bit that controls
>>>>>>> whether or not ->personality is used as a flags2 argument. If that is
>>>>>>> the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
>>>>>>> which personality field to read.
>>>>>>>
>>>>>>> While this isn't the prettiest, it does allow extending with 15 extra
>>>>>>> flags, and retains being able to use personality with any kind of
>>>>>>> command. The exception is uring cmd, where personality2 will overlap
>>>>>>> with the space set aside for SQE128. If they really need that, then that
>>>>>>
>>>>>> The space is the 1st `short` for uring_cmd, instead of SQE128 only.
>>>>>>
>>>>>> Also it is overlapped with ->optval and ->addr3, so just wondering why not
>>>>>> use ->__pad2?
>>>>>>
>>>>>> Another ways is to use __pad2 for sqe2_flags for non-uring_cmd, and for
>>>>>> uring_cmd, use its top 16 as sqe2_flags, this way does work, but it is
>>>>>> just a bit ugly to use.
>>>>>
>>>>> Also IOSQE2_PERSONALITY doesn't have to be per-SQE, and it can be one
>>>>> feature of IORING_FEAT_IOSQE2_PERSONALITY, that is why I thought it is
>>>>> fine to take the 7th bit as SQE_GROUP now.
>>>>
>>>> Not sure I follow your thinking there, can you expand?
>>>
>>> It could be one io_uring setup flag, such as
>>> IORING_SETUP_IOSQE2_PERSONALITY.
>>>
>>> If this flag is set, take __pad2 as sqe2_flags, otherwise use current
>>> way, so it doesn't have to take bit7 of sqe_flags for this purpose.
>>
>> Would probably have to be a IORING_SETUP_IOSQE2_FLAGS or something in
>> general. And while that could work, not a huge fan of that. I think we
>> should retain that for when a v2 of the sqe is done, to coordinate which
>> version to use.
> 
> Fair enough.
> 
> Now there are 16bits for new features, which may put v2 off long enough.

Exactly, hopefully that'll push the need out quite a bit, so we have
time to do something nice for v2.

>>> Also in future, if uring_cmd needs personality, it still may reuse top
>>> 16bit of uring_cmd_flags for that.
>>
>> Right, that's what I referred to in terms of uring_cmd just having its
>> own way to set personality.
> 
> Then this approach is safe to go, imo.

Thanks I think so too, and it'll unblock the sqe grouping. So at least
that paves the way for the first part of your patchset. I'll post a v2
of it shortly.

-- 
Jens Axboe

