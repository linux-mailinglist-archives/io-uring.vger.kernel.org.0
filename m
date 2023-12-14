Return-Path: <io-uring+bounces-285-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26401813E6A
	for <lists+io-uring@lfdr.de>; Fri, 15 Dec 2023 00:53:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8FFA28360D
	for <lists+io-uring@lfdr.de>; Thu, 14 Dec 2023 23:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3362C2DB60;
	Thu, 14 Dec 2023 23:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EUOiamSg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243696C6F1
	for <io-uring@vger.kernel.org>; Thu, 14 Dec 2023 23:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5ca5b616de0so31057a12.1
        for <io-uring@vger.kernel.org>; Thu, 14 Dec 2023 15:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1702597996; x=1703202796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G2vr8wpG8JZogZBD1SoHqQxA1hO0CmvmdHIdK9DqzWc=;
        b=EUOiamSgIdBaO7Re8e4NBX5yYd1QWJc6Yg86PlUiDdw0OfZst3nLhxgLaUtSdvL6J6
         C+7I2TUz0aWSatbAhOVJeVAGc2XuWGGj+vHm7lMPjPA1wlBXDCD23cSxLRjUgRvGQkVw
         TZYapr2nZz5TDeASPPXAmbFpee8eSH1+arftG5LG5z8hnOypo7uNNRdSyhpkO5+SJDmu
         3aR0D2jC1eGWmOldoIMYd7fUgRPuLLTPBODRpRPJW8bwAuQa/y7n3Lbg3HlqtbZuEFFh
         9PI+pdiyzjaTDJTKKnPkYUrrWWHVnhtZoWbUplF44sGsuFfzbOwFi5vlclDZRwY9fAKy
         MeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702597996; x=1703202796;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G2vr8wpG8JZogZBD1SoHqQxA1hO0CmvmdHIdK9DqzWc=;
        b=MVcFWE1TfwzTKWN6497+Qlhe6jtSOlVIfLWRayWpAjZuvr3OkyHqQ72d0KFqqjJIUt
         vIGnlK23U7UzE5LNoVzKKdp1mVTuhBkzkzsbH9GN4MOrfXCuTMlR7FSQW3nL6XvGt016
         4jOcb6zLaxnVlN1VG+aiTpFBhNb+UiMoZbGQ6GygIAF94G40UlrzI51+G++VpbLe4Vpp
         odOqoPUIvRlnVoJbOzqvnAC4qo/Q8Mt5TgiR1etdPGQvcyiHUXI6fvMVT/L/TOadspjy
         F73ht0JxkARycgBZK5VR3EgRftDLO8r52AlomA6cHCs/mTrMxOPhN9W62nR4W2Y7xVih
         7B4g==
X-Gm-Message-State: AOJu0YxBX5U+TjwQ+kRdYA/aBZpmJo+Qe5NiSGtMGYqqEZ5YDnvtJpSB
	5V27DPdpGy8XBGiABQ9PEPiqfA==
X-Google-Smtp-Source: AGHT+IEeexnTETX2c1nFwQZXovhV6Sios0dAmzf8StZwyBO/mpo9MTUtUq1Pmt6IFP3/mNPEccJ5QQ==
X-Received: by 2002:a05:6a00:2401:b0:6ce:4f4c:d475 with SMTP id z1-20020a056a00240100b006ce4f4cd475mr23105297pfh.3.1702597996082;
        Thu, 14 Dec 2023 15:53:16 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id z19-20020aa78893000000b006cb884c0362sm12178060pfe.87.2023.12.14.15.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 15:53:15 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Breno Leitao <leitao@debian.org>, Jakub Kicinski <kuba@kernel.org>, 
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org
In-Reply-To: <20231214213408.GT1674809@ZenIV>
References: <20231214213408.GT1674809@ZenIV>
Subject: Re: [PATCH] fix breakage in SOCKET_URING_OP_SIOC* implementation
Message-Id: <170259799501.410702.15075202098496334749.b4-ty@kernel.dk>
Date: Thu, 14 Dec 2023 16:53:15 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-7edf1


On Thu, 14 Dec 2023 21:34:08 +0000, Al Viro wrote:
> 	In 8e9fad0e70b7 "io_uring: Add io_uring command support for sockets"
> you've got an include of asm-generic/ioctls.h done in io_uring/uring_cmd.c.
> That had been done for the sake of this chunk -
> +               ret = prot->ioctl(sk, SIOCINQ, &arg);
> +               if (ret)
> +                       return ret;
> +               return arg;
> +       case SOCKET_URING_OP_SIOCOUTQ:
> +               ret = prot->ioctl(sk, SIOCOUTQ, &arg);
> 
> [...]

Applied, thanks!

[1/1] fix breakage in SOCKET_URING_OP_SIOC* implementation
      commit: 1ba0e9d69b2000e95267c888cbfa91d823388d47

Best regards,
-- 
Jens Axboe




