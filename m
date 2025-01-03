Return-Path: <io-uring+bounces-5665-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C94A00D43
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 18:55:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1EB118845E2
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 17:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 811C11FBE85;
	Fri,  3 Jan 2025 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MZ0RFNJG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031961C1F12
	for <io-uring@vger.kernel.org>; Fri,  3 Jan 2025 17:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735926892; cv=none; b=hqzD/zvfe03RwFvHc7QI0yaOJgpmWYULscpbJu/+px4P54qORoyMLihFa4slvk/l2WmtH6XeZw/RF4iLD/iiZTjthmXYYbHWyqz6SKnDFHLjnCL013IQ1qHstCnjXtufRk23Guep5Qay8Ko78uvhaabRcgN50UngBpmFuU918zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735926892; c=relaxed/simple;
	bh=n8iLPWxrB7NQBFBZIOKpYgQuHtX65H6p9cchfZEm4UI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ngb73lHvW+QbjWhAdLhB9ewwFpQpMaOhyewj2mp/CY780JdtT2uk7hSIz2ih87dij3a6GhOXBZs51YsDmcA7qcvco24/EUChG8d9+QD4HQVGJpEW61yk12sD8H0Bgu1VvF0zwcIQtu239gLhjQpF3r3OhwEUjLbR+TGfw2MU0Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MZ0RFNJG; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2f43d17b0e3so17927858a91.0
        for <io-uring@vger.kernel.org>; Fri, 03 Jan 2025 09:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735926889; x=1736531689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVuQDINpTz8UXNmuzaULsFIT0Gie7jAL3cjrPfvxwAQ=;
        b=MZ0RFNJGhN6aVGooD1qOPjWCenLzQKbdAiF7DxhJ1NbaAsIDJtHwyMSmgnVWJL6hAr
         SX/czIdRI/F4y/Y0rIC1cSv5v1Lo9oyPfIYVpjeXloBXAQ+wJ6bd3FfP1jdCkx1odN85
         FXXpjemsWNwJudN5RF37/Lt1vmOX4AFaR+pRfuTHtu7DWFluq6Bic9Q1WpuyIPyqh9Dg
         6OrF8qsjRYJ1KJZbeGkd2hniIDEvIUw4Aox2lz9qMZ0otwurxNIeEXq+pJsfdNo/pQjG
         9+NVLQCjI4+OYgb9QRPBrYbPSwG9LmP3YLz5VMW+IWocVPEVjN3SNgtNIkWVgq6hvBly
         JEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735926889; x=1736531689;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wVuQDINpTz8UXNmuzaULsFIT0Gie7jAL3cjrPfvxwAQ=;
        b=wH7AF/PVktlQDnKsutzKpO+6YgGCsfTKxfVhET2M33L7ICNFxaxbT9YjBIDovcHmjJ
         42xaU46GroBvEZTg2XobW/CMco6iy9uTuCCdDQ7lsbTk2h/7QoqWNai9OhSU8XpRzGm/
         65Dg2x59hTvfCabd+Pw66XepMiSisS9m0f1AhMcVP/7XgtgZFSiJsaX5+JwVje1f8clD
         V+aPHPnYTWUYpPHcXZfqD89V3MA1dgvOOkC3I+FA5oViS/Fw4Iy/ifyIq2tUrQRPLeay
         E3AWn3SlS+Vv35e+zc9MNEU5PTK/Q8gOPznOShTEkKKK+kmZGPUpUTlO+kfOChwRgG9y
         3J+g==
X-Forwarded-Encrypted: i=1; AJvYcCUydD7beFcXtIMGWxabcsm0e47nX8dQcMSTJNePBnpzAV3WCXbBZiR1yuXC9+fSQpzHMeyHlYv3Lw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrfa30sNMLcmSw0O+mSywTZcmbsGnLEgGMNt/RPYe39ZBOPT2V
	kRLFjdUAApKjBFRQ/tPqHVJGmG3ZM4pJU5on9IFoLlGg3KCNfUeEP9t7v5bjIIdzmryv9wUs8rG
	z
X-Gm-Gg: ASbGncuVF3QfF3UAO1keQp5ulglpoKrm+EWjrIEs3SlosMHgkxQ+PXdY6AFTaDsWldh
	/RBzGLCKvI71Oj5WyrEipvYAYVmTeEO8ejlLMTdabDbppD6tOYFL2onrGap6a3nH3jfShfcSvLy
	j24goKBWCK4tp0jzZ7dow6v79qNXWxw0qmTmcW7ApJn+lIonyQMOJ/NBVc7qXxVy+G+7dNNfm0D
	SrIMS8QoNh+cy4Fi+EKNDHfQYt4Fgn1noTkOBWpxABSSh7/
X-Google-Smtp-Source: AGHT+IGdvXoJZDE7q/I+uNpbgios/+Ub/Nzph4mdknUS196VUuZ497YM3KVoTJ5vwtWLum5pc9ytQg==
X-Received: by 2002:a17:90b:2f45:b0:2f4:434d:c7ed with SMTP id 98e67ed59e1d1-2f452e1cc5cmr75810861a91.16.1735926888836;
        Fri, 03 Jan 2025 09:54:48 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f72b8sm247880835ad.191.2025.01.03.09.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2025 09:54:48 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org, Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <20250103150412.12549-1-minhquangbui99@gmail.com>
References: <20250103150412.12549-1-minhquangbui99@gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: simplify the bvec iter's count
 calculation
Message-Id: <173592688762.163907.9105296507610787608.b4-ty@kernel.dk>
Date: Fri, 03 Jan 2025 10:54:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Fri, 03 Jan 2025 22:04:11 +0700, Bui Quang Minh wrote:
> As we don't use iov_iter_advance() but our own logic in io_import_fixed(),
> we can remove the logic that over-sets the iter's count to len + offset
> then adjusts it later to len. This helps to make the code cleaner.
> 
> 

Applied, thanks!

[1/1] io_uring/rsrc: simplify the bvec iter's count calculation
      commit: 2a51c327d4a4a2eb62d67f4ea13a17efd0f25c5c

Best regards,
-- 
Jens Axboe




