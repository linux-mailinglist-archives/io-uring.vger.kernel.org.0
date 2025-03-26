Return-Path: <io-uring+bounces-7248-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC37A71CA3
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 18:03:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C330189CC3B
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 17:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 881B01F872D;
	Wed, 26 Mar 2025 17:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="VE0zrHam"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718A21F471D
	for <io-uring@vger.kernel.org>; Wed, 26 Mar 2025 17:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743008497; cv=none; b=EVZDyJkaLJq58stkvBHJhkOrM7afy1zwahb5juFD62Jwtbknl4KWMr/oP90gtMj5ie5XiLR79JE8XWy3Khrk7WCnzQNGHy6OI+ltotzRVB9FakXVpf7oMcvicm5e4NaO2d6Asp0hSYZYbZyLdeM6x+QQN97h/h2EWdDbXcrLgf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743008497; c=relaxed/simple;
	bh=m93JNtthltSSbcTrFMDYov9U0XPQF5pmKwirD1tHohI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lzcg3gpl1LXlpRKNosugiXYIIK4akutgkzyENvRIpkEYipG8kEsMyGCBn5UBHkpzkt0DRukYi4e3HniXHDXb9WjYHrAXJ8CbYUYUtOX6ZAKfp0lkOMP9jDfnmwoU7HK6+yt4/1WQH6zPw15G/Xyuy/8sVL1dHcWOfsXdNWNuOnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=VE0zrHam; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2ff5f2c5924so1753472a91.2
        for <io-uring@vger.kernel.org>; Wed, 26 Mar 2025 10:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1743008494; x=1743613294; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m93JNtthltSSbcTrFMDYov9U0XPQF5pmKwirD1tHohI=;
        b=VE0zrHamGe+C/d7k/sAqno8unsnbmEBOPZCITxs9vLuILC9fvtFwAOEJRDchwfGOuR
         bamBdeLp8PEI28zs8kn8VnnspaIBZmSnWWd7si4b3v0H5W017omAsDb2DwctB3ErVfZZ
         z7Lpbmd1rIb3tDZHjqkUsf9dCKHPFeBjpOAnz2AYADCm0ELhkIVRCQy2genzjbuGNx/W
         5W2HRHe1xdn3p+6FLBCs+wGB21onG43YZFrkYnxFHuhiEbSp0ljKNDF5QBaPBIJE4xjd
         M6GB2PImLW+zMpoOpnVa24u4WKGDoAPj88JbY82VcBYxvSBoo01YxbQobcoZYRKbZcgU
         WCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743008494; x=1743613294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m93JNtthltSSbcTrFMDYov9U0XPQF5pmKwirD1tHohI=;
        b=cvmmZzo4+0+xautXHVTRpdnrDEWtQOlFQo+fuCCGbtyFYyBbTAwm4DAEoZzVmKAuzw
         YXRV1YWh2TYwxeB/fX9MPqEVdfplsAZgv2NU33ZItPvTZKGVeaCki48mXIhYOP2mwXgq
         NGpxpEvmsoZmyo7AKxyZLYsd1uC0ZHXiI2r74GZ8XeRLuce7ppoHGIM6VhsStN1+8Tow
         uljoHwWn8Njuu1FdzS+rmQpUO5Vp+kV7pLar8EEK2LKvSPt8J5mWS/MjHwXg03EKiruH
         nYE8Nce4JFuV+zi0Qiw82D7RggEZZE+H/269BBBTu5Pzsb93a97qPExTOQrCaMnhJz0Z
         iIWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUnIK1HLuvHI3npA0z63UuyqjbDUOHMqfxHhLNmE2Hzh2QRMkind8RbsfTw98t8OUikQ1lUIOBpA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjai+1QDGhUVM8b6kwiekX/aeLu1E4nADgce+C0eJuyo1LV4nD
	M47NQDRkEoPDILdB5JV7MCOVWnO6UAiJTRm1jqKP90CU30YwkI2s4DdE2+URClpCfOHDWRvIb7f
	G5ZzvGHWBn07qG9pNAnjHH9kMaszVlhREmbGFOw==
X-Gm-Gg: ASbGnctwvBWFBMNPIV1s2YsGmMgAYcIFd1iJ9A1usJ+1txtaHSoRKmG/zQ6HAYeLZeN
	Qm8rhPlLpMIAni30RfD1llT7mge/V+8FSpxpDmbDrEsCL4djmfRWfe34utf70dFCfgHTIDsRVVs
	U9pPL6wlYD/FkAZ602/PUXjEDN
X-Google-Smtp-Source: AGHT+IFjVsGE/uI55/GwMic0rGrb/4ccYRlzq+3uz57glJBeCVvxaKFA7tRt4tikiIMHIU3n67/yVuVxuutCCLJ6PoA=
X-Received: by 2002:a17:90b:1d8c:b0:2ff:7b41:c3cf with SMTP id
 98e67ed59e1d1-303a83c306fmr191288a91.4.1743008493555; Wed, 26 Mar 2025
 10:01:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250325143943.1226467-1-csander@purestorage.com> <5b6b20d7-5230-4d30-b457-4d69c1bb51d4@gmail.com>
In-Reply-To: <5b6b20d7-5230-4d30-b457-4d69c1bb51d4@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 26 Mar 2025 10:01:21 -0700
X-Gm-Features: AQ5f1JodO_70bFedzA9NLOdpPN9pHRVHSWvuZt04JDJWrhv2Dx7TEG-gTyKLrrw
Message-ID: <CADUfDZoo11vZ3Yq-6y4zZNNoyE+YnSSa267hOxQCvH66vM1njQ@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 26, 2025 at 2:59=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 3/25/25 14:39, Caleb Sander Mateos wrote:
> > Instead of a bool field in struct io_sr_msg, use REQ_F_IMPORT_BUFFER to
> > track whether io_send_zc() has already imported the buffer. This flag
> > already serves a similar purpose for sendmsg_zc and {read,write}v_fixed=
.
>
> It didn't apply cleanly to for-6.15/io_uring-reg-vec, but otherwise
> looks good.

It looks like Jens dropped my earlier patch "io_uring/net: import
send_zc fixed buffer before going async":
https://lore.kernel.org/io-uring/20250321184819.3847386-3-csander@purestora=
ge.com/T/#u
.
Not sure why it was dropped. But this change is independent, I can
rebase it onto the current for-6.15/io_uring-reg-vec if desired.

>
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

Thanks!

>
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
>
> Note for the future, it's a good practice to put your sob last.

Okay. Is the preferred order of tags documented anywhere? I ran
scripts/checkpatch.pl, but it didn't have any complaints.

Best,
Caleb

