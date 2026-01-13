Return-Path: <io-uring+bounces-11621-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AF262D1B3D2
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 21:38:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 264A73089A03
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 20:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D7D2BD5BB;
	Tue, 13 Jan 2026 20:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RZXJ2gc8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A26296BBC
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 20:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768336552; cv=none; b=sCndTCmURw6pQjkcWfIqeDO//eGqoSffDEfmPazhM3imvraudSouDohMC/3IAIyv5MMOdZJJq1IyljC3wiNyFCub4AW0z5NqbxfCasf09n8HP+Jo3sINMDPC4wWKLJtGXaMQno+cO19nywUvmulmUAU9BsOIljCaDHKTpBXhcf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768336552; c=relaxed/simple;
	bh=cKg7v2KzVBD68e61oktjgujD+AbJ8BHRF7pWtfi27Dw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Cid9t0GQUi/0Ygz+q6AXfk2/uRjc9wEf4IFw/9Ap4q0zqqTwPrZgfAq8QcQMt2qGdfQdXsfoeYkfbaEvAU2fhDiX0eapYO53vPdp0c1wq5m6uEKboc+VdaNemj/UtQiVOHwact4lXIWd3MSS7prr59sOYij3+iSevhImb/dWBJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RZXJ2gc8; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7cfca52ac2dso5800a34.0
        for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 12:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768336549; x=1768941349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5kOWAZUZ3E1w9NeFwOozUCNrLF7+ZNwcVAr8n6zpo30=;
        b=RZXJ2gc8uVOq+E6+r9CFR/wWcblXmu3jYLpbNvfgxExem/q3eOKT1ePwzTjdvjYSP2
         snsaQ6smWeBHeXQkLGWFCkc7oqlssFT5/45p9sA1RRlICJ5qKbXjAeXv7VhirztW2gWX
         9qxvTaQfn/xJPvuB4We7pl1vn1sumhXJNue/QIyQVvKflMJengrXmz46vuNHlapKnJSZ
         feRsS0lN2ec+bx0Iyf8ciAHk0k1ydgGDMhZkV2ijYpG8J7/JStbxLzVrYMS9XENHfIof
         lduuNWqz+jQkYfyathl8zEGjeEMYr55yHBNKZ33qZJmFztp79XZTIaazpkHGdoiYJyA9
         IdeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768336549; x=1768941349;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5kOWAZUZ3E1w9NeFwOozUCNrLF7+ZNwcVAr8n6zpo30=;
        b=qeWa01RNLrr0RpUKuYUmDOcLjTvIcsDFHD2almZUs4YDfRRevAekeagNAXwV2wovqj
         86yz5c/0OaH4XZjazGOkzZo/ghMfiuIFX/O8w5hEA+t9JYKJUnLYRhCg2v1eYpGS4k5F
         FrGBpLlObUKat1CYlDnBKcaoAdMoCGjskmTzmtYvtKp1OqNsPIMGQpNYL81yZLL1Drx0
         2jCWwWLAjUcSdc5OKebVCf1RaZ2wohlYXdiXS94wUdVg1tcdoMY4P9dGErxlFMhi/xGK
         od+MHY/pLxJeev1QtjBte4K/ZdPQZY8Wt0PUgSDruD6XxA721Jx8qK6P5vbD2fABAye6
         gxLg==
X-Gm-Message-State: AOJu0YzolQe8I4BkH6gviWbwX4TJ1CjLyHYYZp0y9JBw6i0qLUpQ4ejw
	V2F1bX0mA8qkWl35aQ1Mxfl5YxxFADDe+jq++xA+co6OY6l4THgrlmSXULcaTy3690hrpmZ2jZ5
	CzYlO
X-Gm-Gg: AY/fxX5XAMuVUunpAeR3FDlMQpeuVNHMc/PhfBVDx1S4Rul4xupnoDxycgBBEUYIUnz
	l0hXKEPaIyZPSLuK7IJYTJu0yEVpIfi4TfKeZDA4Lpfji6UQwAMqoFJsJVNEdDho+19K+dKw1L2
	yI96g+ccQoXGxlkRfUSYi8iYHKZAa79K2chBARrOgpxaoYAlYRVz6g/FBWxgpgLdv7gH0TmToyY
	gxGUq75u9M/8jPD3hBVzdfK5sI5IBFLBxUTsM4TXuchdhDTVbigX94zOYDC8MSsTuQ9bSL7nnSN
	K3arZ8yO1lBRAeAtLIcQnHq133fp+hu9jcoKATom1RBsEm3HHQja+KGWhuHh0iOyXza7NRrfkGr
	i5QMIsbdMF3h3jU0e36RpxLhBx7ED0fuV4PyMzH52GEuhkNzaFsKXOJuMIqRooOooE0tdrqDqkK
	qt0w==
X-Received: by 2002:a9d:7a85:0:b0:7c6:e92f:41cd with SMTP id 46e09a7af769-7cfc8b39fa5mr185196a34.32.1768336548845;
        Tue, 13 Jan 2026 12:35:48 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478af813sm16438444a34.19.2026.01.13.12.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 12:35:48 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
References: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] man: add io_uring_register_region.3
Message-Id: <176833654804.353309.3877899629297261335.b4-ty@kernel.dk>
Date: Tue, 13 Jan 2026 13:35:48 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 13 Jan 2026 20:05:05 +0000, Pavel Begunkov wrote:
> Describe the region API. As it was created for a bunch of ideas in mind,
> it doesn't go into details about wait argument passing, which I assume
> will be a separate page the region description can refer to.
> 
> 

Applied, thanks!

[1/1] man: add io_uring_register_region.3
      commit: 416ca5e33c07f8eb8a5bb83d10d4594cd2def528

Best regards,
-- 
Jens Axboe




