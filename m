Return-Path: <io-uring+bounces-1538-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 105A48A4451
	for <lists+io-uring@lfdr.de>; Sun, 14 Apr 2024 19:07:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B2831C2094E
	for <lists+io-uring@lfdr.de>; Sun, 14 Apr 2024 17:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 692CE1350CD;
	Sun, 14 Apr 2024 17:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c/TBudxM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C5C134CE8;
	Sun, 14 Apr 2024 17:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713114459; cv=none; b=NNadFuVoVhELS5PrndO5wg8I9a7jkMlHqOYrzf/cyT9cq47vEW3t1nsa6AsYIOgKl18qKCEWchpoyIwH9DFREYY6ZtvtXxr9v+jl4dZ1gHHu4s9Klzet6tX9g7+XQIuv69HVgvlJnBlO62VtoUGd7I4o17MXm5UnIKANMP8bPPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713114459; c=relaxed/simple;
	bh=Ga8Kp8utPgdMxZju6CZ+8DGGlYgaWLPlT9nyF9eci1c=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=Ug9/BEUZCEJYVWC20hkmlnUtInAlnA13X7FbgArkowXlzCKlYYrI9HrJbWp6XnZ8fIbtBiyf22c/TE8SOTym3Br1LHKqh/UK1cTIZtK+KRvDGwYq7oGqhutWh0hLMM2G3TaQAXGk+4isAlKflEloxIiWQfCp7HXMQXjUhdxpHks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c/TBudxM; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3c38eced701so874031b6e.1;
        Sun, 14 Apr 2024 10:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713114457; x=1713719257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ga8Kp8utPgdMxZju6CZ+8DGGlYgaWLPlT9nyF9eci1c=;
        b=c/TBudxMy1WIcRDfdhPtScESwF+Chpss3S6lGAr4+lRb+7WbQYGpB2F0hD1EkNXS8A
         pqhfCD2YXVQOstcEPFMo2BM/0E08bN2/+zmoD60x6Y7xNZ7CcgB9u7HyC13MAx2QPGb0
         bcc/pKQaHuYuYDwKwUL7isfxGz1Uo4O3d+4SBepri9cb2hzsjDfxqxusWs6YDwVpmbGl
         OoCkpAyy/7ueedgsDZXaPVammr08ajNXE4cTQMfjueZmVky0anZtuieSnaAkveZTYXhH
         YiWkxYi6wLTosgGvFQ7sBH5+6NegB0QESw5gty6GzUGJz88slN79Wtr0gqZDNK01Risv
         3fSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713114457; x=1713719257;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ga8Kp8utPgdMxZju6CZ+8DGGlYgaWLPlT9nyF9eci1c=;
        b=dH7gmJxA963eMsmrFNYSN3i4mXWzeZ6JD+7OFgwG4MeO9fBfZrPUjhWUss6AWhQB4G
         t0nQB4bSoEhoZJR1/nMpXf7kbzT2HgHYfZ+2Qu6Dc6KjtNH5wBeTjcN9KHFqoU/mJfjK
         g324PTfPZf0T8FghC+wZ4TXzhd+DGkz3QxpdPVul4x2Pu+VeekLnrB7vyH10v5LB9dyq
         8FHqqCwiJKpdQjbNooRaR32B+YKqgCTKLZj28f9BeUYvE9SRjy4THSKTsqFlQU8LAPBR
         hcSMYmqqVMTcjiTcvH1ORRkCQPmT3f1C/NVPSey046FJ9HMEGQ+rHdMUzjxR3ccmE3YO
         xJ5w==
X-Forwarded-Encrypted: i=1; AJvYcCWEBFRcXM/fko7BxGwT/ESvF7jyzEwPb8cNvg/I1h084ye4g98TN85xsVPOTJ3Wy2gKxyeCuOySGD7LE0IQesyzEuDtVNn+DqJ7tN3O4kGeGdYlVcQ4Cp9WgQPHmJK00lY=
X-Gm-Message-State: AOJu0YwiWkJoxwEoctDN+qpsul7JV5vs0Aeiu10juO89t26CBtsPBGX7
	qny2sBJ5K6GCGI7rp9dS4yn5UK5VqmvD+y/Ql/XBaIsFvdcFXQpD
X-Google-Smtp-Source: AGHT+IHOX8phXh0G9epRkcqy3l1tk+SAxXpuASFos4suXPaHQzc5dcSeQy4RQx/uwuFv31NZ7lS21Q==
X-Received: by 2002:a54:468f:0:b0:3c5:fa7a:69b3 with SMTP id k15-20020a54468f000000b003c5fa7a69b3mr8109044oic.35.1713114457193;
        Sun, 14 Apr 2024 10:07:37 -0700 (PDT)
Received: from localhost (73.84.86.34.bc.googleusercontent.com. [34.86.84.73])
        by smtp.gmail.com with ESMTPSA id s8-20020ac85ec8000000b004349804eea2sm4906466qtx.48.2024.04.14.10.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Apr 2024 10:07:36 -0700 (PDT)
Date: Sun, 14 Apr 2024 13:07:36 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, 
 asml.silence@gmail.com, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 Eric Dumazet <edumazet@google.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Message-ID: <661c0d589f493_3e773229421@willemb.c.googlers.com.notmuch>
In-Reply-To: <62a4e09968a9a0f73780876dc6fb0f784bee5fae.1712923998.git.asml.silence@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <62a4e09968a9a0f73780876dc6fb0f784bee5fae.1712923998.git.asml.silence@gmail.com>
Subject: Re: [RFC 1/6] net: extend ubuf_info callback to ops structure
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Pavel Begunkov wrote:
> We'll need to associate additional callbacks with ubuf_info, introduce
> a structure holding ubuf_info callbacks. Apart from a more smarter
> io_uring notification management introduced in next patches, it can be
> used to generalise msg_zerocopy_put_abort() and also store
> ->sg_from_iter, which is currently passed in struct msghdr.

This adds an extra indirection for all other ubuf implementations.
Can that be avoided?

