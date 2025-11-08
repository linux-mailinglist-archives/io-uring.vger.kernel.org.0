Return-Path: <io-uring+bounces-10451-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E24C421DB
	for <lists+io-uring@lfdr.de>; Sat, 08 Nov 2025 01:18:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 862EE189397D
	for <lists+io-uring@lfdr.de>; Sat,  8 Nov 2025 00:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FB7B1C861D;
	Sat,  8 Nov 2025 00:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xPRwT2ba"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C948119F137
	for <io-uring@vger.kernel.org>; Sat,  8 Nov 2025 00:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762561074; cv=none; b=ajdu2h8iTlDOnrg8cFpD5ennQ9XJ9+SwPE1NE47YrzKjxQuv3PWD2IWdMI8P+BBpizpRQ0+KzeVn8bXMeCTqWxp0pVM3rIvp+NG0P6ujVoKFqP+scohmbR62n2bbiLyCPFrrE4wdm+G0CypPsZgU5w1BDh3O3H2MFygHPO6Ab9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762561074; c=relaxed/simple;
	bh=BoGNMYByoUWFxY2vGbaeZ8uIyLwelreTZLwjTfGBZzY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=sIwP87SudyE3Uuo7CssWTunl9M54dCZKxohtnZulu/LecLZQSbh1osxLLfTqKLcCE/kkVlgfu7ANQbUxG5twfSIY4KZ/IaiSHvEbTdqrTH6xPclYYmZHxHC2V9yt+mJUFt94Jmcm1/G1VTEbG2qHg0lsOskPAR/zSXdTnkU8o/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xPRwT2ba; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-88044caaa3eso13478606d6.3
        for <io-uring@vger.kernel.org>; Fri, 07 Nov 2025 16:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762561068; x=1763165868; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=02QbLJm9M2Ty8aVORegjYUuxZZCgXfElqF6yPxRbJCk=;
        b=xPRwT2baM450eudzaMUK3HGKn6a65tiUpIp8jZj+3wB+zukTMf5XaGGpMdM+OI5SLw
         rr/yo12d3tZd0pnezB/7OTsZ8Qd81eZwZc9l+s4WWDOX02VG2ulpyl/2sMdPjdORByuW
         zOJO9PFp3kfl7yTIxo6jzKcLpJW87VG/7ESyWUO9BiahiDN+AuX837058Qmi3LWQWKYS
         u8DxEm0YvFqDUWmaulx8Tkn2ZgxY6v/k5Sbbp8gR0clXKGuNklYk+o2OPJsZzs68Fo7k
         YJ7TLZM0fwE15ndwcOSwwM8/BksucPpNqsQmUtC4DYIdj4mrf83Uz+4xBYipTtEfgELo
         EF0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762561068; x=1763165868;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=02QbLJm9M2Ty8aVORegjYUuxZZCgXfElqF6yPxRbJCk=;
        b=hPWAYxdvoxKHQRyDFPpou8POoPJj58Mv9ydt6pdcErwJIEVvaqCUIk0kq9kECIDoh5
         jTvblY1nfMWtq1oUzph5Yn+k1/B9KPWuhNhrnALEv0apAEl11nS8353vn8EL/4B7NXDh
         xdR+OJDMqGiN98CdH2iS+gW2k84UFwfHaJ+IbwUDYrA68Bgd0i6xQ8eLQJcGcYkXVIMD
         qoCuevh88QjvFMK0kMV0FTvszJMbxqiACbzsWI2S2uuSbDMZgMgKnQ4sA20JlMpicMAC
         z9DKRm0b7t6aPCIt4FGEVvOa4nItLabVLInx7g10pkwVgnRkCI9AzNtKr7ji1mKjnHde
         GqbA==
X-Gm-Message-State: AOJu0YztBcOOc2t4DCVR52nnliPxY7u3BCcnqr5ctAOsifjQLlu40CPK
	uSWk/JEW9WC4o/arxm54jJUJB26xUGBZV+0ZxdelmWl+gEM2i/AanwNKosL/m2W9skEd0nSRf5F
	yAS/O
X-Gm-Gg: ASbGncvoXBVR5rC97SF2zazbIzBiRmdI1ySAwGrX4bjtWaWUCw6sltPkyodhLnLcNSG
	fg1Tnr4GiiSARtl32rZ3OUYlUFV+gN0vnorOxFLjdI0ZBWUOUdae3xgCo+PAJoeQczY0x+SeQqh
	sZhl8HfhZRgSjXBQofkliAtEg9lhPTDsjBeSDTOUeaPmXCjbOrwXHGbNQqsHMMAmqu93F+HBiLR
	7aD5FYsB3ZCfQYtpfqwoCempwBMsVLIi8k7AiJmrSRhnaF0YxIaIQq+yphpupGdOOStFm9HlzEr
	EVpw4SnILE+AFfkehmy1nbqeAIOlwE4i68gF4H3seOIer5f+9/T0VT0AiqXcr/4afFuTByMi0cV
	ma0seJZ+5JPjgPTvhR2v76Kg8XtvxdAEDJFWNBfhHG58fsroJRRN4C3laHzbtz+YrWcmpvd0=
X-Google-Smtp-Source: AGHT+IG2AHaDccwTL1Mc1awJq/itZhnIQdiukqr+6SEcB5BoelyTiVrd63ooy33akGd3uqzR2MbPaQ==
X-Received: by 2002:ad4:5ba2:0:b0:87c:1ec5:8428 with SMTP id 6a1803df08f44-8823871ae60mr13512346d6.46.1762561067818;
        Fri, 07 Nov 2025 16:17:47 -0800 (PST)
Received: from [127.0.0.1] ([216.235.231.34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-882389a857bsm5870136d6.24.2025.11.07.16.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 16:17:47 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Google Big Sleep <big-sleep-vuln-reports+bigsleep-458654612@google.com>
In-Reply-To: <11fbc25aecfd5dcb722a757dfe5d3f676391c955.1762540764.git.asml.silence@gmail.com>
References: <11fbc25aecfd5dcb722a757dfe5d3f676391c955.1762540764.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: regbuf vector size truncation
Message-Id: <176256106677.25337.10211644340240412795.b4-ty@kernel.dk>
Date: Fri, 07 Nov 2025 17:17:46 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Fri, 07 Nov 2025 18:41:26 +0000, Pavel Begunkov wrote:
> There is a report of io_estimate_bvec_size() truncating the calculated
> number of segments that leads to corruption issues. Check it doesn't
> overflow "int"s used later. Rough but simple, can be improved on top.
> 
> 

Applied, thanks!

[1/1] io_uring: regbuf vector size truncation
      (no commit info)

Best regards,
-- 
Jens Axboe




