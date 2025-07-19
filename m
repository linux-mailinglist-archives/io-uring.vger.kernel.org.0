Return-Path: <io-uring+bounces-8731-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C09DB0B0EE
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 18:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15CBD3BFDF1
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 16:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16733286433;
	Sat, 19 Jul 2025 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Npfbnnrp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53203FE4;
	Sat, 19 Jul 2025 16:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752942904; cv=none; b=jcPFSEcH60ov2TMWK1G4kkFMtFAJADU+RbYbfsuOEEVdYjtIMCDoefqu/uHAGGJ8zd//gWPyk5Lz/3/pT9xLrRlXczoDfZ+8fjtB+6G/g29e/LfFDFsQC7T7uEfnK/X+/2nXQE2EZXX7/ibbkpKPDrcgW6wi07EZsKag/NlCZSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752942904; c=relaxed/simple;
	bh=1/MLNZVSJ1hk7ujQkzcY/AOfnRMc7rFvzC/avgQR15g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cIri/Ev3QjDJH7vEGeTCSRWN4hsL7Hdop+m2dr4TEfVykYzpWe8UCxS2PriJGESOKSsdNkccPZw4Y8cZUP4vIaP+5jspjZubGNVkUSJnzl1pwptcmKvANj6WP0Oghh3pmYpyvIlvJwb8lyh89jd5kcRDqLfK39ICSAmQnOMR0s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Npfbnnrp; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-31308f52248so514889a91.2;
        Sat, 19 Jul 2025 09:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752942902; x=1753547702; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/MLNZVSJ1hk7ujQkzcY/AOfnRMc7rFvzC/avgQR15g=;
        b=NpfbnnrpaOcLpAZXcEthQZ0Qk97GkXoB0TZVT8v9LSv9wwRtCwzvPQUAZQMQzzpTYc
         N5j3hkvLaRgwas8C2S3G21UWRJcfRtEc6h+/B+Y3uvG9Q5mimOHOozdo2EPrjnZ4FpwE
         yVjD5aAqD2h6V4Lm4ch2LTQ8LwYHK4dKgd8tTSSP8t78pqSSQDo0/e0uRG2fy45dy+ss
         zdGK7m6Eqfp55/Eoq7r0Ju7MGy5ctv2dvpM8hyf7B9kvr447Wun5n5ez2V91lMjA9pA2
         tw6+SmT4tqFhUsw7SFP2VD6UVi1kD62Jp1TCOBlGFItBHTh9izcew9cuDQccZKwq8I+3
         8Edg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752942902; x=1753547702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1/MLNZVSJ1hk7ujQkzcY/AOfnRMc7rFvzC/avgQR15g=;
        b=hoqNYK4uYJA9BGKgAE3yXt9eevwyBrHx+WtevJuB36SuSlItqqBoZ1gSOI5YmIhrsK
         tu0iWY7Jhnx44bevwToNgbETnIhC0yvtQraWdZR1ScFsVyK1rCycz4KW+ywKmQdDGKTG
         QJ+XcuhURsVR9hHsvyMMKCAP4g5FdRa/U9PyqK9mStsiuo3KrcRpRzXeB2dJljt2xcZ5
         ct5UWFfzoLlt3mA8vSWEwNwMsrVpxn/aP758CMQqTAYjCC+ZuLI+5qnLrm/MB8b4KH//
         XW3wypChPubkATILud/EghTMgTBU0tSupVDRlIaf64L0WpnxkWpHisXOQDz0w68Uah+k
         TbhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNeA07PZZRzH5Yc3ea5onkCaT8Kj2rV3T87malbYO2l5LBLsZDyRQsN+4L8VkFvBQxJmYgjwdJ4PtidAtkvWM=@vger.kernel.org, AJvYcCWUVT8oRaKcT5+eLsoQdkHVpau2kFzqKk2ROpufwZEh+yc1eb3+sWHFbRg8SZ+29oAtA4XmckJh2DsECycp@vger.kernel.org, AJvYcCWVWxh2SGQ24e1q+T+KMRViWBL5u0lTAKwCMc7QcMCZVs/QApH5rh3Xg4AROyi244v6JJWTWkU8IA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkKMp0tNNVSCuLEVZ2ls24XvODicC8ldI21CbyeKQ+IPQloEhz
	B99J9CBMxxze7WA36DMY6qpbUUhq8I+obcr7K32rWZGFsXjxVCDgNJiFgxpICe9R+YZVBTN+1O3
	zmOgrJnhlwag+wuposCrEsTLfRem/WnY=
X-Gm-Gg: ASbGncvzKE/R09HTAW/peTbe2dKK1wH2DeICcGM/ctqOpI3m0//ambH0wR5QXfRu59o
	hJ/f4HegHQC7UPp/ouFv65bIMN1C0wjce2V3JzWznHAfxMQg8dTOlovDH19ivagym9keZS5m+sd
	JW180+6uXPnH3thkfXeWf1ZGjSNPFO4wDEP4OBiNlRqootmn13M54iItHO32vvT2bKaDm3E4hfE
	/p8QuCh
X-Google-Smtp-Source: AGHT+IGUsgkwCBh/QHiyE3C+argEC+dPKGffPBQqpeYPqCLEp6MJWJBLKzU6Rnv2VNgz+oUc9cSKcVNn93Ts8VfrE8Y=
X-Received: by 2002:a17:902:e747:b0:234:f1b5:6e9b with SMTP id
 d9443c01a7336-23e24eeb3c5mr85817975ad.1.1752942901920; Sat, 19 Jul 2025
 09:35:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
In-Reply-To: <20250719143358.22363-1-sidong.yang@furiosa.ai>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 19 Jul 2025 18:34:49 +0200
X-Gm-Features: Ac12FXyPff5Y_jyb2pa_7x3el2jnqM_E55kOMCErVFiRgvbAvcE_oH_TjlWk9EU
Message-ID: <CANiq72nWFW-5DFJA31ugMY7v0nRNk6Uyb1KuyJfp0RtxJh3ynQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] rust: miscdevice: abstraction for uring-cmd
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2025 at 4:34=E2=80=AFPM Sidong Yang <sidong.yang@furiosa.ai=
> wrote:
>
> This patch series implemens an abstraction for io-uring sqe and cmd and
> adds uring_cmd callback for miscdevice. Also there is an example that use
> uring_cmd in rust-miscdevice sample.

Who will be using these?

Thanks!

Cheers,
Miguel

