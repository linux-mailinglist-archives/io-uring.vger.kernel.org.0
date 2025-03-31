Return-Path: <io-uring+bounces-7311-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7DCA76693
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 15:08:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71A627A21C8
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 13:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE24211282;
	Mon, 31 Mar 2025 13:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GswH929C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C398E2AE8D
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 13:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743426484; cv=none; b=u5TzhBxTy4iW8cIpw7wl2FVOhxGP8WczRaewc5Kpt/4YD+COKN0tLTvDFqLD88gi/w5IhDL+UXwGLSc9ZWzEoaKsO9JXvisGf8D+JWINAsAUyx7+UQHldHKP7v/APtPr1CyE97+vTFHRwHk9q1GZnXm5PIUU1/anS0KZbHUoryo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743426484; c=relaxed/simple;
	bh=Kyl7WyECGVkrfbSK/CEUM4TCfZu65qRnH7WfznYrBws=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RNf6kzfkMELthfm9uBtqaeDR1pHbeT4U3g0cagtVnxh0HD/2z8owNa2oXcR88ojVhI4xso3D//EHi956uZ6Qygo2a9ywejZqXbvw5iFFPE4Hui3QqHyxj4g9ILIDJsWd3KM7+/28t4x2t97SgAXnLMgWmPdmjJV39rylbBQfalg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GswH929C; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-85b41281b50so97361039f.3
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 06:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743426481; x=1744031281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c8VFCtjxl/49gndeDOmFq3Y5bezFfRGgPAav3gPmdoM=;
        b=GswH929C3PZ01FskFej4V4KhRmW2tgRMEScRowpIDUDbINCEU1HFgqjRUa9iNctFdM
         SwQmda5u1o4BookyHEzrrkUBXmx/iRUBZoL65t9HffZ5C0glzFfv+1k/p9JO3njc7PcA
         O3IAIRSURtQACHhpz5TcikMV3woBF1ClXEtkvwQ6yUWa+V/0g0zcGPMH+P91KprlQlV0
         BJQn4ZdXYVC8sF/gSLmrVQGBiec99aCgKajNgNklW54CgXv8x31OVdZReJbjVom4AmHf
         kiUiNVwnn/4GgnnNJA2X2LkRAb8kevYeBBwlvG2EPMzaFRMxLP9j8eEfM7XeEZtT0NW/
         4dLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743426481; x=1744031281;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c8VFCtjxl/49gndeDOmFq3Y5bezFfRGgPAav3gPmdoM=;
        b=UcxgLXHDNpmkuMrikBY2PKRhK06wvIwozLGLScmAIf1Csq5jgoFy87uHLDxsOGTxKi
         CR2r6QnQXmQd0gytXLTLu3xXEIUO6IsuUwWhLR/yB9htEDZM0h4BdN0Nlg1YVHlO4cVr
         oakuOcxDgHU/spxsqSbNG0+89uJf6P2wFm7JcyI0Se9epBCr7Ygli03xrZpMo7zFBPM9
         nlk3xBYw/CnQGZJm89SiuPD2izhf4ZjN7aOcr+leV41yqbkV3u8C3V4KD5VoYnRNix3e
         YYwgR8od2cRCImCKH0P32f8GLRShPYlDYXFUbNGG3Y/2wWA6HO1M0OE4MsSS3HPjSEOU
         5dNA==
X-Gm-Message-State: AOJu0YxVkC/mIwanPLgtIz/QmNyukXrLVbti0sxOncJld+eKDBZubgT6
	Rh+/Kd531WceO6Ep+AlWSjOZSYw1bNa7UXntppiFWsH66sVU2Nfr0+GVUZqiBP4bnp8Lo3cCzXF
	v
X-Gm-Gg: ASbGnctZ6IKcH1Q4PjXCvvTfARyYBkNOm1ILBR1LIdVNeFg2D4DRQV3LEAFyeQACJdT
	dY5ZNqqwd197Zs2QNY+rbV6IwAyxVejFOcfTBFhL/pYF4XHFbP28i+7JvNu/rQOHIM29plHY7+Z
	SMSjKsXZ9V/IfYRD+0DST51OpIjLic0YBodKZokNUlGzpf45hlyRpHpYkb+EqCU5Gwmf80y18Rf
	Qd0AUxvP2QhKXA7IzLz3hn1hbOfagIlOOmIaFt7pKm8F2iBqq0T776tJT2uu8dNyNwHmv5gtdRk
	athtBDvNwvSbUem9aRy1bnfgaEt9o7FyaLqeCXdgm/5Jjos=
X-Google-Smtp-Source: AGHT+IE1hDCePLei1itpgVaXYbckJ+dtXBr1D2Wi28ikxp7ixgTFSqv7Ug5pPXUIsr9XWI0HUpHSVg==
X-Received: by 2002:a05:6602:4807:b0:85b:538e:1faf with SMTP id ca18e2360f4ac-85e9e88fb89mr774702039f.7.1743426481502;
        Mon, 31 Mar 2025 06:08:01 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f46470f1aesm1822197173.13.2025.03.31.06.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 06:08:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8047135a344e79dbd04ee36a7a69cc260aabc2ca.1743356260.git.asml.silence@gmail.com>
References: <8047135a344e79dbd04ee36a7a69cc260aabc2ca.1743356260.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: make zcrx depend on CONFIG_IO_URING
Message-Id: <174342648019.1704853.13591008878890971405.b4-ty@kernel.dk>
Date: Mon, 31 Mar 2025 07:08:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 31 Mar 2025 08:55:32 +0100, Pavel Begunkov wrote:
> Reflect in the kconfig that zcrx requires io_uring compiled.
> 
> 

Applied, thanks!

[1/1] io_uring: make zcrx depend on CONFIG_IO_URING
      commit: 487a0710f87e7fa1f260a1b2213b77f0496cea43

Best regards,
-- 
Jens Axboe




