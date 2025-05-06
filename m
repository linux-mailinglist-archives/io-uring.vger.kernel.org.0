Return-Path: <io-uring+bounces-7862-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F28B0AAC6E9
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 15:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E5F84C02BE
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 13:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82BD227A44C;
	Tue,  6 May 2025 13:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bv6kS37O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA26028152D
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 13:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746539317; cv=none; b=gEGxLqXjCIstl2o+E7L2elNN6lBHpIQRNGSA2Wpw/Y4/1e2qsrec/r6UVExhiipZLdGEPvK/dXwgTcObkoovArzcJ1Z8q0ORAQUBW2THqdHfef+qlpH8Eq0AypAcxQQ1SbFiFO4vTCmM8UndJbj9x3C16QA43wFPjEYJvKeLixs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746539317; c=relaxed/simple;
	bh=98GUGGp4xOZbbuHc2eOGIvpIRU0hZXsjstXd1+jLwNQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HCQg4whLjmB1yS9gZXRKmt3YxsKWuC10p9C05QaHcvZYa6VmjEH7uUAxpHIRAsao64owXJwiOoZS9Ymv/KJ86OJ35piQJfjOl8bLkuMKENqLoLwJXPal1fTZxzPRyTWZIaZaEwsAwizBu72iQ4yiQuc3iVgUN6NsCALLHdhmgpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bv6kS37O; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d81cba18e1so42071265ab.3
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 06:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746539314; x=1747144114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EHf22trzgmjx/CT1aYLRXkFsJY5UI9ZiTi4mrItLjtc=;
        b=Bv6kS37O46iI2/JrW0xtLm2nAuW3s3O8O0mQs1lGk/TUw7WMVYi4/J5Ls9t8ww0fRk
         qfsDxcoXrFiuSUyHHTqiiZ8q7sC23wM2kxBs5eKqtASS4CC5FwzO5lbJe5Eq2oVYSryW
         AJoSewoKwA2S2svy5IqT0IUU70eCFH2HG5RsieHoCYmVKPikNAIKWqrpY4GAEzThj6UQ
         rCzjQXywOJT9iUiOQQm/7aOepgRSvtbe4fCH6vxI8Z3uU2GNESbu2+H9VuMFn3gn5fQv
         5ld8/RCPL0t+bmrRgj47NPudJUdUyJ3Liw2+H4vfuHOkYmWycu3ykdUkrhDfuWmwwm/k
         bLUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746539314; x=1747144114;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EHf22trzgmjx/CT1aYLRXkFsJY5UI9ZiTi4mrItLjtc=;
        b=tN6z1Na2abEwezYnoky4mHeVvTz20QHxTNmxqHzhRaoYpkrW45uQ0U+ZOYJAtL3NbG
         /lk7U5IVUAFMl1mUwo0C3l8ZehGbVpoegQY2q/QvQUK/9OuPY2nQsqwrenRa+j4RgnwP
         +svHN+UZ/XP2rV1O3BUs5b2CuQ9OmCpLXAmKZc8/SZN06NlnmgknaY7ruifhefR7HSH2
         HgejvzyqQ63hM0TNGwnYTixsieMxoGU+cEzRClUx0w9T4z/4j5CIdRRIEQ6BzfxQlMod
         oauZGae/fOzbk+sGRMuR2FozQV/ZzeU9ATm1fh/OFajkekb8Gor3QVhZ+Y3Cfgf+fZS2
         O5Kg==
X-Gm-Message-State: AOJu0YwNXuX3xkZY8qQvnXq+HflwQOp9BKfNKXMEF+aDqSp2pcrBxnIR
	tP3Rx5W2h/fmFlm2OA5bus2eJ79JL80INYfUq4VuOvtrGY2EBJhWpdQz6hBwNDF62mqAtMnN35b
	X
X-Gm-Gg: ASbGnctTy5wlztBZKvLm19aLWQiine+7QVHd8rIDmPs0PZdNfmJmmEkOK3PuPEyPgk/
	4kJTVWAaSqiUYJDCDuA34RoeWai6FNHXv2W3DCJ8XzaknlSid0cwWUdvXBAuDIWONbDZ300zcsW
	wy4tfbfEzAM4xUBiCCDJiWafRQ+wvYf29W7EzbMBNXrT0+neOiywCmrBdtHEEzSSXd+VcyNkLlI
	OEUW/rRzyffAqK8GLU0dPeMf3ixRQJlRSxAjX6xAQODWqcdEt90u9GHVssxKtObODL6QFlc2zC+
	A9uXgpNYWxWMMw40xm/h5jVC5NZ/gWU=
X-Google-Smtp-Source: AGHT+IEuNp00qFZPzMvxowQWq7F0/2KhNJj40NAJ19KVQ4JRJImb1r8iLQBH6zu6P2RhrrF/TdQyUg==
X-Received: by 2002:a05:6e02:158b:b0:3d8:21ae:d9c with SMTP id e9e14a558f8ab-3da5b23bd5emr124203005ab.5.1746539314371;
        Tue, 06 May 2025 06:48:34 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d975f58be3sm25930915ab.58.2025.05.06.06.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 06:48:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ba5485dc913f1e275862ce88f5169d4ac4a33836.1746533807.git.asml.silence@gmail.com>
References: <ba5485dc913f1e275862ce88f5169d4ac4a33836.1746533807.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: remove io_preinit_req()
Message-Id: <174653931297.1466231.10187787110387595116.b4-ty@kernel.dk>
Date: Tue, 06 May 2025 07:48:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 06 May 2025 13:31:07 +0100, Pavel Begunkov wrote:
> Apart from setting ->ctx, io_preinit_req() zeroes a bunch of fields of a
> request, from which only ->file_node is mandatory. Remove the function
> and zero the entire request on first allocation. With that, we also need
> to initialise ->ctx every time, which might be a good thing for
> performance as now we're likely overwriting the entire cache line, and
> so it can write combined and avoid RMW.
> 
> [...]

Applied, thanks!

[1/1] io_uring: remove io_preinit_req()
      commit: f37d2ddd9cf118f885e2e610ad0f717a7d126612

Best regards,
-- 
Jens Axboe




