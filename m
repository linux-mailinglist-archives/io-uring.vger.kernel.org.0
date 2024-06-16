Return-Path: <io-uring+bounces-2230-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF6D909F05
	for <lists+io-uring@lfdr.de>; Sun, 16 Jun 2024 20:14:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47B9A2847F3
	for <lists+io-uring@lfdr.de>; Sun, 16 Jun 2024 18:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BC893A1DD;
	Sun, 16 Jun 2024 18:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WhsdNk43"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F2A3B79F;
	Sun, 16 Jun 2024 18:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718561679; cv=none; b=bqaFiPfUk0FNTQ0Q2ZevJUGJ0y3wSHFE9Xdsk6CVsrt+KHUNLHjKHrr+vitmgWPzfMP0PRe6rKxslqL79VhhJO49CUwNcViPg9clSkOIhFkhMsp5EJoHLL5eZrIy0qEhPraWHs834/vbWGn6+iRCvls8X+lEV/Xdy6pqs4sxrts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718561679; c=relaxed/simple;
	bh=jO/Ij/+uJk7TSK+6B9w3pq+IWHdt+eMkSC4oOAlbw20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F2NnBpI4ltpolCeun68g79qRxpm3txqOLuChDg7Zj4j9kQwgnL9Bq5EPy2v9SlS+rrVLuC8R0i/YZFX6UP5BtJ39W234ztME00ss0JvQBuFxfMrlU+1E+sGeYlcSX2lz7qBKwyifzQtKR/Db2ZZcZ2o05uMA1WduNGmIMdUQ0Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WhsdNk43; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-35f0aeff7a8so3094064f8f.2;
        Sun, 16 Jun 2024 11:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718561676; x=1719166476; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XltCGJXe8n1cKNvzAidWwoDjkjoXQrL4w3HUnlFK3/c=;
        b=WhsdNk43PiDaJsvmT3pwwhkq1vWtsXIjEZfZscndvdaW13H0CW8uY99/cgK9Wg0E/p
         KR74IllYteyWafGb7aGrjAVPxBowolzXVpe4lijuM5OXDagoF64RSKqyxvj72k8JnMRt
         CkDmHPHR64a+Om80nXe0+ofIzc6Wze/wWE/0qLNIhJaNwSc90e2guza0tIO1yYNgaa4j
         KF0xoxYXkeLNNy26nIy5MRAgJDI8BN6N13Y87CRSEnHohi3ASicXl4x6b5mXZvpGYyfB
         aMKjUHGgLgoYUHCA5AMhCZhP5DitCJljokShTcHhJhQu4OQUfrGIugHtvNmb2U4xcBIl
         Q2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718561676; x=1719166476;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XltCGJXe8n1cKNvzAidWwoDjkjoXQrL4w3HUnlFK3/c=;
        b=iYyvWLqcylw+aR5RVizWkTrhFfjvrLJsazccXlbH7WC3/kvW8r0gzPqdr3Z74F0bZB
         gj5kFHssC8amstzWACPqouMDcHWjyB8sX7w1tK6uaO+v1kVuamEcc1sVjSeN26TpzRmA
         XnbK8HlV7ZlcYuir2M6Oka7DTJD+jpedFwUAHCBpZvKuf5Y16AGup2Zvc369qk0VIi82
         V0Fx2iV+AhFiXwjKiKneVDyZIYkQ+8CizyTyL5WmVE/5p1jw2ZsCc6cLX89yYZf3kXBn
         oCAjrP+2jOTv8Rb+9VCFDU+bmWKZE2J1zFqpRAKQuW6pBiuMJm/iPhDRYb2aCs2MmwpJ
         BPww==
X-Forwarded-Encrypted: i=1; AJvYcCUQNCwVHD/WE5lqkOPli1Td0riXjg0DK6pCz7jz5KVkHVZLrDSJ9wkQ/AluaG9sZb9QQwv5a/ZPGJluvmfuusGKw09F+Ml396pe/5f5ViyZgy0NJRCRsrnRhCrEXJUZ1nAtnOYiJA==
X-Gm-Message-State: AOJu0Yz5fK5C3MMdNVzvjOCZuHcU0T43ffucvv/WAQhwkPICBfveNza5
	l7/Az7qURhX5nN23fcI9jBCj6EiMPCr8p0oE/wTFlarOwudelIau
X-Google-Smtp-Source: AGHT+IEEcdg1LjEqq07i8fc1WGXUY7ets2iFNokMUzxmRPvdR3BIwJgz4pK+Cv39RdmCcX64sDGIqg==
X-Received: by 2002:a5d:6d87:0:b0:360:791c:afed with SMTP id ffacd0b85a97d-3607a7b3468mr8312152f8f.13.1718561675638;
        Sun, 16 Jun 2024 11:14:35 -0700 (PDT)
Received: from [192.168.42.249] ([148.252.147.74])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36075c6fa4esm9969622f8f.67.2024.06.16.11.14.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jun 2024 11:14:35 -0700 (PDT)
Message-ID: <7a147171-df1b-49f5-8bf0-dd147c6b729f@gmail.com>
Date: Sun, 16 Jun 2024 19:14:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 5/9] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-6-ming.lei@redhat.com> <ZkwNxxUM7jqzpqgg@fedora>
 <3fd4451f-d30e-43f8-a01f-428a1073882d@gmail.com> <ZmhR3/TipsQI5OxN@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZmhR3/TipsQI5OxN@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/24 14:32, Ming Lei wrote:
> On Mon, Jun 10, 2024 at 02:55:22AM +0100, Pavel Begunkov wrote:
>> On 5/21/24 03:58, Ming Lei wrote:
>>> On Sat, May 11, 2024 at 08:12:08AM +0800, Ming Lei wrote:
>>>> SQE group is defined as one chain of SQEs starting with the first SQE that
>>>> has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
>>>> doesn't have it set, and it is similar with chain of linked SQEs.
>>>>
>>>> Not like linked SQEs, each sqe is issued after the previous one is completed.
>>>> All SQEs in one group are submitted in parallel, so there isn't any dependency
>>>> among SQEs in one group.
>>>>
>>>> The 1st SQE is group leader, and the other SQEs are group member. The whole
>>>> group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
>>>> the two flags are ignored for group members.
>>>>
>>>> When the group is in one link chain, this group isn't submitted until the
>>>> previous SQE or group is completed. And the following SQE or group can't
>>>> be started if this group isn't completed. Failure from any group member will
>>>> fail the group leader, then the link chain can be terminated.
>>>>
>>>> When IOSQE_IO_DRAIN is set for group leader, all requests in this group and
>>>> previous requests submitted are drained. Given IOSQE_IO_DRAIN can be set for
>>>> group leader only, we respect IO_DRAIN by always completing group leader as
>>>> the last one in the group.
>>>>
>>>> Working together with IOSQE_IO_LINK, SQE group provides flexible way to
>>>> support N:M dependency, such as:
>>>>
>>>> - group A is chained with group B together
>>>> - group A has N SQEs
>>>> - group B has M SQEs
>>>>
>>>> then M SQEs in group B depend on N SQEs in group A.
>>>>
>>>> N:M dependency can support some interesting use cases in efficient way:
>>>>
>>>> 1) read from multiple files, then write the read data into single file
>>>>
>>>> 2) read from single file, and write the read data into multiple files
>>>>
>>>> 3) write same data into multiple files, and read data from multiple files and
>>>> compare if correct data is written
>>>>
>>>> Also IOSQE_SQE_GROUP takes the last bit in sqe->flags, but we still can
>>>> extend sqe->flags with one uring context flag, such as use __pad3 for
>>>> non-uring_cmd OPs and part of uring_cmd_flags for uring_cmd OP.
>>>>
>>>> Suggested-by: Kevin Wolf <kwolf@redhat.com>
>>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>>
>>> BTW, I wrote one link-grp-cp.c liburing/example which is based on sqe group,
>>> and keep QD not changed, just re-organize IOs in the following ways:
>>>
>>> - each group have 4 READ IOs, linked by one single write IO for writing
>>>     the read data in sqe group to destination file
>>
>> IIUC it's comparing 1 large write request with 4 small, and
> 
> It is actually reasonable from storage device viewpoint, concurrent
> small READs are often fast than single big READ, but concurrent small
> writes are usually slower.

It is, but that doesn't make the comparison apple to apple.
Even what I described, even though it's better (same number
of syscalls but better parallelism as you don't block next
batch of reads by writes), you can argues it's not a
completely fair comparison either since needs different number
of buffers, etc.

>> it's not exactly anything close to fair. And you can do same
>> in userspace (without links). And having control in userspace
> 
> No, you can't do it with single syscall.

That's called you _can_ do it. And syscalls is not everything,
context switching turned to be a bigger problem, and to execute
links it does exactly that.

-- 
Pavel Begunkov

