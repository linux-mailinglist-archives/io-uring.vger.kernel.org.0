Return-Path: <io-uring+bounces-4273-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DFE69B7DCC
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 16:07:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9ED191C21343
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 15:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C71D19C552;
	Thu, 31 Oct 2024 15:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tc7js3bR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AC719F406
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 15:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730387244; cv=none; b=MyP5pxTYAN7VpDgqnUBLXyQBKv/DASPgeNXZdFDyVsovRn6bjxqEg63T3UWQVWT7cuzB5pxru0CQ5YCGis200ngng9fxS/XAGbHJm59FIpevQboBYWouOqmDw5azaOKo5O7yeUC+jS0MIus7AvUdOhVUn0dSxsqUouUICLDBBG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730387244; c=relaxed/simple;
	bh=91tAvQ83xBc46G4koXmUCJaD5io6wSvNhoxK+WGNFZk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=huvI9ZixUpEHIHobEwp9fJnde3DMuJpE/ZxRmJ7Q+ku7k8fka2ZHs97CaTeWBsHjLby9Hwhakeuwl4kPx5Sp9aFLp8kCfGNJS5Iourbai0pMUGDMQ2+SURAsP1YEdWv6yab1EQSPjE+/VZLDdhihCc6WeypJgOR24MSII6PV7UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tc7js3bR; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3a3aeb19ea2so3849015ab.0
        for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 08:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730387240; x=1730992040; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NPL0PCNbmEqD8r8cbgZ9GH/XUgdz2tIwqRDBvk3oWCk=;
        b=tc7js3bRYPUtO0hOqq/ehue592AYTahrGXQwhglgX69LhlutBzQrMa76xGzWLqQPOH
         f2A+u5b5nm4WkjD3fuYd3hH+np7zMTRrxGXwscG3kBHRQvm/Py5atYsap95c7+0uEBLv
         0gmNHaZl2fViDH3v2iseWyCjvlbc8H/iXW4Tm2f71Q47/w4FSb/yJBvSs6sEgWL51g+Q
         xKb/L6UVUSTi8nrtKf1vpysfbMdL0AlAk0cudZkGN18lpR2wzn8dR2SvutaJA8IMwY77
         2MflgsjFOwkkTublMjdndT7HHkI1JV2NAhYS40LGxSig5B+fRNCNQU56N84gCg187OaT
         4WJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730387240; x=1730992040;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NPL0PCNbmEqD8r8cbgZ9GH/XUgdz2tIwqRDBvk3oWCk=;
        b=j+j0Ap5gJ4jSzDmU97JEzZybqDtrLVERqeGaPkq83ndKvmBtNCbMYkQRj6UbzzTwA8
         lLr2RRjrDweYcHyHxKDbqUcJDzKMqcTHc33xUPOwvzrNL2oApdhtbX49FvG1+v9RJfw9
         8uS0Z3h77Q7Am6USo0cB/MS88N3uT7PHiaHjCD25tVcQ6iEuBxjbsOvCDuYWRbQaqVqW
         OB8Ih9WCNmtEhG7YOD0ttFQ2T1x9kBmJBrRdJOS6G/c99nbEXwkIpUxO1VuKLZRv9n+f
         F9XbsGBCs9eVGqAzz2iozoOJrY6jMeGrAdrFzEgeV9J6T+uJYgElb1be/55shOnWp9/U
         Ne4A==
X-Forwarded-Encrypted: i=1; AJvYcCVhF2wxKPJJW9cXTugkV7t43yeglca6vFn/gpRrdtFWwh/4bnKI2KhKkefq2LuQyFbWmAiPNN2MRw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHno+rgiS9tW5SKWPTdMhpbuAWkYO4+lKLC0Q5Fgow8cY+/GVY
	Er18h4+f8qR5/WzwdkBtwQoTQw9O2/cD5w4Lkt/OFJOpPUOiXpIM2G3koZ/qP0ro4bCaNYSon1/
	61h0=
X-Google-Smtp-Source: AGHT+IEbci1KaplCW/wzGBnx9hlaJx/LzhoEL83R0CzDGNDdGxwkz+Tuk3wYvzFMZg9zvkTBVrP80Q==
X-Received: by 2002:a05:6e02:2188:b0:3a4:ea4f:ac9e with SMTP id e9e14a558f8ab-3a4ed30fef7mr194074745ab.26.1730387240031;
        Thu, 31 Oct 2024 08:07:20 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6a97b0038sm3725365ab.1.2024.10.31.08.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 08:07:19 -0700 (PDT)
Message-ID: <d9069c8e-6a58-4574-b842-f1e1f20c55f3@kernel.dk>
Date: Thu, 31 Oct 2024 09:07:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <ming.lei@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <15b9b1e0-d961-4174-96ed-5a6287e4b38b@gmail.com>
 <d859c85c-b7bf-4673-8c77-9d7113f19dbb@kernel.dk>
 <bc44d3c0-41e8-425c-957f-bad70aedcc50@kernel.dk>
 <e76d9742-5693-4057-b925-3917943c7441@kernel.dk>
 <f51e50c8-271e-49b6-b3e1-a63bf61d7451@kernel.dk> <ZyGT3h5jNsKB0mrZ@fedora>
 <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk> <ZyGjID-17REc9X3e@fedora>
 <ZyGx4JBPdU4VlxlZ@fedora> <d986221d-7399-4487-9c28-5d6f953510cd@kernel.dk>
 <ZyLxJdn7bboZMAcs@fedora> <63e2091d-d000-4b42-818b-802341ac877f@kernel.dk>
Content-Language: en-US
In-Reply-To: <63e2091d-d000-4b42-818b-802341ac877f@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Another option is that we fully stick with the per-group buffer concept,
which could also work just fine with io_rsrc_node. If we stick with the
OP_GROUP_START thing, then that op could setup group_buf thing that is
local to that group. This is where an instantiated buffer would appear
too, keeping it strictly local to that group. That avoids needing any
kind of ring state for this, and the group_buf would be propagated from
the group leader to the members. The group_buf lives until all members
of the group are dead, at which point it's released. I forget if your
grouping implementation mandated the same scheme I originally had, where
the group leader completes last? If it does, then it's a natural thing
to have the group_buf live for the duration of the group leader, and it
can just be normal per-io_kiocb data at that point, nothing special
needed there.

As with the previous scheme, each request using one of these
IORING_RSRC_KBUFFER nodes just assigns it like it would any other fixed
resource node, and the normal completion path puts it.

-- 
Jens Axboe

