Return-Path: <io-uring+bounces-9646-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F142B4914A
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 16:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A67E07AD5C7
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 14:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62C3C309DC5;
	Mon,  8 Sep 2025 14:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XdaW+D0X"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C77A1E5B64
	for <io-uring@vger.kernel.org>; Mon,  8 Sep 2025 14:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757341356; cv=none; b=HxxsBEkOOHo9yOvoBVqNnPvoAbqavJkAuErc1RyFZ8++a//0BEZxZ/RiuF7lmth7B44iOwaUEzA/UjX+hNWXHYAeTo6MOL/JPOg5t8m0z/2zOxP3ucycc/Q2Ebp/ayOGJak3+JwP31cgxHmEHDa3aZi10cZYgJFTtIGKOiJR0H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757341356; c=relaxed/simple;
	bh=gk1ToXqLVfFHyrhWVBDKXmQcXtkR/eVynveNUsyE22g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kprW81bXg5J5BNGNxM3hxKqqUJvKQMbLVq+ZrVpWdixjhyivg1bDBxYP9lgtEqfTU4O1RQ5vnQtR0xwZ7kpIuVyVb38AT8G3/OttD64xH+CO5zyQBnUib88A/ErpniyPiq5eg6PatAtf3h9+C2Zug8ARIEh3Zgtlubhkrw2OBz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XdaW+D0X; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24b2de2e427so31251245ad.2
        for <io-uring@vger.kernel.org>; Mon, 08 Sep 2025 07:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757341353; x=1757946153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xrVD792Ek2sgQfwhqN9PhoMMPfdppvwqZK5xGEitoko=;
        b=XdaW+D0Xz0SAkxhCv6BaXxx9xY4dpBeMisoO1hCObKrbBtQVGV+fLwKc50FxFCIt5c
         eW2AVcWNH2oC0gAAhxqYS5ABBX8w/5xZ+y1b/9KqfdoUw+G4sdvaF35QpsCaPRsgHMpl
         N9nh/q50fUaA8cipHwMIwwg1MvdoEU8WC+bWJk2/ZfadDr/FaAx1yLHS8KO6p+1H871B
         fGx6wfc3DKVGEzo+Jz3O9umRHmj74dczSdqTW5Io9R7eT6DP7LDm7gq1GDRWzL1qTCcc
         xcAE4M0/LtxZuLJYEGQUOS55iL5W0cShel64uELBbXhqHLahK2gywGYCEYV8s4j881BF
         q7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757341353; x=1757946153;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xrVD792Ek2sgQfwhqN9PhoMMPfdppvwqZK5xGEitoko=;
        b=w3+ka5sObsxoDDbS4ozcV/UHDF+SniVyW0WSEq0u9NydpQh5UuBcI1QBPmXZ2yhs0N
         ugNRqKs4i4ZZ6dLYoNutT2eRUE7LS0Y94EDGovGbGt98MBcVIkfr0aUUcrr1Y6fxe/7G
         pD2VADWeFzwwPtmqBmlAH60JyxTnOQRFbYogmE/ovix2B1HV5INDzn/0hOlOYLpg6M1s
         1KT8HLDeMFaZdNhiEvZKMvTivBndO7uPkOLr5/+ZVdJhdiJ7U7Lu7P3poKxs8I409fci
         CqodGyRIyY1+CERjKpeye+YVnIqvv7HcHt2+obOd7myyDkKJT+hduYCEhk3q90k01deE
         V/Hg==
X-Gm-Message-State: AOJu0YxxbrqgvrglMjqABqPnXWqclga3Tl+0Eh90wa/EOZNx/FmaQm+a
	xg4eLGtjsMtZRL77YfdLxP+Qq09ftG4pkwVqv44d38eNEJu3rua6eXiKyY9YSa8U2k4=
X-Gm-Gg: ASbGnctykHqrQabwt0KNfAnp1jC5GZn2L5Qt/Z6aJYSU+2BSJKmRuSaXRJhFQ/rmR+V
	X+T/YD74QygyzCKirp8bK5GD2lLPk30beU6TmFEdulpTKvxvqBMLKD9bkJij0wQJ3PP3JFOc7gd
	AJHbL2eW3ShG35eS6A4UCzujn9eT8OwQI2AIrzaMuzhxvnK+S7JZsnu1WHM2Ffy4dZpibeCKBBH
	EmnM8DlVoGaq+cJx98vFxR4QIMqr+anqUT2N93HTKR4sEiJ1tIyhrR+8VUuJviA8jrPqHGBZlzU
	c7C0/VKN1Z+HlxGrNeVJ6nUnoKI8j7aqoEDYMUAQP3Bk7lJAXgiN09d0eyW53Pp+k6QeyjmDcP7
	oNzEIWhIzoR3HDPTfGbSjhjkeUg==
X-Google-Smtp-Source: AGHT+IHGxLKpvVKAbv0Afa6m356ddtcVCdDITBH1IV2TsqY9fFZ958JktDTLLt5K1bQmXfFDf9f0Lw==
X-Received: by 2002:a17:903:19ee:b0:24c:bdf5:d74b with SMTP id d9443c01a7336-2516dfcd7c5mr112932595ad.19.1757341353623;
        Mon, 08 Sep 2025 07:22:33 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24ced7ea5ccsm96723125ad.111.2025.09.08.07.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 07:22:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250905101817.392834-2-thorsten.blum@linux.dev>
References: <20250905101817.392834-2-thorsten.blum@linux.dev>
Subject: Re: [PATCH] io_uring: Replace kzalloc() + copy_from_user() with
 memdup_user()
Message-Id: <175734135265.533336.3277901531044251712.b4-ty@kernel.dk>
Date: Mon, 08 Sep 2025 08:22:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Fri, 05 Sep 2025 12:18:17 +0200, Thorsten Blum wrote:
> Replace kzalloc() followed by copy_from_user() with memdup_user() to
> improve and simplify io_probe().
> 
> No functional changes intended.
> 
> 

Applied, thanks!

[1/1] io_uring: Replace kzalloc() + copy_from_user() with memdup_user()
      commit: 7b0604d77a41192316347618cce1d9c795613adb

Best regards,
-- 
Jens Axboe




