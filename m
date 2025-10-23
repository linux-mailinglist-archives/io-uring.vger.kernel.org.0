Return-Path: <io-uring+bounces-10160-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02A35C02242
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 17:33:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B33623A5F35
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 15:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E4F339B42;
	Thu, 23 Oct 2025 15:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r76C1ksd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5C5328B59
	for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 15:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761233348; cv=none; b=LlwzP5LRjRHEtY7yX96y7nzLNx/uIwGYo897GaycvYjGyNwfO+0ktEZQLyPf/ITHyj+jH/qN6yX8KELlZfm3adVBWUzupCC4pfXwJ90CoSA094nO5QZ4609ZIPQaE0rIhx+RC03SX/kqYujUfB5gRvg1BJklmXsf+6fI2LCCRb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761233348; c=relaxed/simple;
	bh=GNsO9gYg3pFCwdQbMH64G5NArVp39u06+wfFho+vgKI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=m6BHFM35IOBWU1LuFkpBx26vqpcqGPbyrB+RinvnmTzp4ezqlFjLGe+rYSjfGIRUhSLltDHIGticR20DtTUcrhJ1khBNzkaApSOdLYJpZxEbC5hfBRt31FdpdHT66HfeFUe3A0ZGDkSFt0ksAuBdr0GmpRAVUiueaMvoL0811Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=r76C1ksd; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-93eab530884so86748839f.3
        for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 08:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761233342; x=1761838142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sa1ZLi3wlzJPgrSXxudWeueoGnzUlj7sHp/0/xeThEY=;
        b=r76C1ksdFjdSzmxzvOHKbmCNClbzLvT+JMkbjfMcGUP9zkBMID5YHySf28EJ4ba7Oy
         WPOL4Hes+XGw2u+3kZFoWXh6Bn6vXmjfUyuIE5cGwHcKzr/jX1i6BJ4faQZhL9iIwR36
         XOIb4L9WckqvFpiP3x7d+EdoC3dMIIWSxY0HMJD6z9PMF6C2LO1cmlH4wE88527YYp3Y
         aMAPT87NkNlKZGv3686YSJ0VVVZvFrx3tne6KJOprGdAOhvmUz/CPms/ncHSue2pqqZz
         K1A8MW4vMT7VrqAVHupd7Qnme824oFabAwvo182/fxjXcjS6rEtrlnhfd1pE+XoDXh+s
         WXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761233342; x=1761838142;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sa1ZLi3wlzJPgrSXxudWeueoGnzUlj7sHp/0/xeThEY=;
        b=WkvSgO4YeduHWywWeAUssiUiOUEOZP0bcry7U9Z/PWoII8r9ci/quVONAYkvfa170b
         g/2EtroquhXewPFnpfTZCuYkPPLNNYjr6TIfsAFjDs7cRomfWLtGNnyGWnGtsfjJ7CGJ
         s9g+cJkQlosJDoragJT3XKgfYF+0UsRFpPAutTk2tkAkqkfbiui+ZVUZYe3UV2FvZTmQ
         ER5UY8n3W7Ngg54WEBG8yxc9Ht6n9lzpGJHGJCTt+JOcwlO9VCv25Ai7zLL13kbxovGb
         RceRyzUfKspd0znM6ZFhh6YTSiHewgMukxB6vDlkgH8NUw9Rof8sHQXNBFJQyw7CdWaq
         ZO+g==
X-Gm-Message-State: AOJu0YxWm7LZVVd2kBRtE+FtvOWVjk+E7OFBjqmHfDnzpTma4mrLVhED
	MCaAllY19MxPeEvUl8w1fBv9Qfz5eET3T8VyWy8MesOZwjvfGjPeBqm9aJ2eXM/0yxDFVdIXFsS
	ta6Gk0lE=
X-Gm-Gg: ASbGncsRuXLq5jdcSO9Q1eo7u0hDUgwgYInbgB7vKH4mFueH9Ofp95zlw3eDMBDVXZK
	NBtQFS9tM5Q2wNxBasM+aGrCmbjYIdPBEaaCDqkN6XdIff5BKbyLRBuQpNccvPFBQ4USvXgOUYH
	L+a6ChRSx9J/YwZCwczw/EnbVAQyYBT+4z9FmBOtJXCoVoFo2pCzDb0cQMOaXUIXTfnaWrsbkLt
	MIoDalu4spXsgm1A9dSxkzC7hRD7J49rfUORDTxbK61DLPrB78G3/xHlY2ITg05BRU0ltx0JbhT
	gUixo+M1EhghO1QVdIYPP3JQJRsY5zsws1kqG4+XTZoYCaRoLV2AZkKQGaz+8PtKFCQ9aw9qjy9
	j48np3rBJJ0kOgUpgJEt21NDhSf6df5zijXOO0R1NnFrG3187ru2H4DIBLD5A3csQtv0=
X-Google-Smtp-Source: AGHT+IGPJEGMZU/EDWHXcTbwYSqkN+m+Ftv9Kb8bF88k8yB37hsscaaEAFRLye9AcXz92WitSRvhlw==
X-Received: by 2002:a05:6602:2c92:b0:93e:8beb:bd5 with SMTP id ca18e2360f4ac-93e8beb0cf4mr3100327739f.16.1761233341873;
        Thu, 23 Oct 2025 08:29:01 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-94102f827afsm82757439f.16.2025.10.23.08.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 08:29:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: alok.a.tiwarilinux@gmail.com
In-Reply-To: <20251023115644.816507-1-alok.a.tiwari@oracle.com>
References: <20251023115644.816507-1-alok.a.tiwari@oracle.com>
Subject: Re: [PATCH] io_uring: correct __must_hold annotation in
 io_install_fixed_file
Message-Id: <176123334019.219627.1294409242242167269.b4-ty@kernel.dk>
Date: Thu, 23 Oct 2025 09:29:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 23 Oct 2025 04:55:24 -0700, Alok Tiwari wrote:
> The __must_hold annotation references &req->ctx->uring_lock, but req
> is not in scope in io_install_fixed_file. This change updates the
> annotation to reference the correct ctx->uring_lock.
> improving code clarity.
> 
> 

Applied, thanks!

[1/1] io_uring: correct __must_hold annotation in io_install_fixed_file
      (no commit info)

Best regards,
-- 
Jens Axboe




