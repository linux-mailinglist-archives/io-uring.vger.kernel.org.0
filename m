Return-Path: <io-uring+bounces-6673-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ED73A4208E
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 14:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47A931884E22
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7689C24169C;
	Mon, 24 Feb 2025 13:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ayqAN3nK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA84924EF88
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740403466; cv=none; b=ZEovA5Eg41GRQoAME0v7CTG5Ju4GgfqyDi1dKXUp3fUV0MLws3+xp4egrl690/Qq9+Svs4Z5S2zT+SS/lhOM0B33EbfXxvRinjUk0k4pMcHsmgZHs85lf+6I1z1PMHLONml0otTlFhFhLsw48UHu4C8qQc/Qsn0x+gRhxQAqzNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740403466; c=relaxed/simple;
	bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AAOrdSVrvH/oLteUSDEX0EwQ79CrbDX3UJRH+ulFlgvRi4WGLKN45ofWRdChLZ1X1DaK39lu3XpnEelgqzvDT0nECxXcjhgvVJdn2KWZljeSLonk+EHfWequ7qVEsFk9GIQBd39FYlMX9bNSjHdGO10Kx2Wae2WiyfUs8kqRzx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ayqAN3nK; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e058ca6806so8006273a12.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 05:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740403463; x=1741008263; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=ayqAN3nKOAxyMVa1LFXtpEzKk4c7g9UlSHWP9KfFGmqmbUmPaKQgZe7RvAm3T2z+tX
         K+9j198MDJYYjlsqTZxdZUvAWWi9XK1xfGe40ZCfK2qqNdskN42OJJjNfse9DMZswxZB
         J2YEIu6G7Yu9OWybYqcahC9WuyFNILVxt6ptPkrWx0gbQlcAQcFybHcyPI5bOq5FQhTd
         VSo7jJMMKFctmFbZTgw3+CUPmE2hkfMlergdnVe0M1/e4kgTCSdpUhvQdxvBG8fcjP15
         xDzxX98RIDVZ5pV1Q4Das8P/mM0+cBIgW1MUve1ogXqNlUKfJPrOwDVtzIJ79J7VJCP9
         mK2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740403463; x=1741008263;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=OqRNLIPx0dqGyPU6nk5GJ7/6Zv688ugfnGCIPX1D7oPsR7vu14MbaqHYY1QiHQddV5
         78ZgadPD4BqogkaB7rhhA4BKWWGs11xQDfrWelenrOG8yIHR4ymvy5Zfh1ytrVUMH+AW
         x+CN0CDbl2i3SMOVgNf0InZyuy+RlPtiegY3noI1MzBgKzJEpICbW1KuAXi/Sgm590fG
         hmHIFs6RnfaXvz/icveoak9iSHXQlJtTIx7vqaH9saDFTLfJsU/3pXm75KAWUm3blEwl
         0AOAFV/LCe+PlLrZiaSbXnX58owyn1xNxDi3x1DlSiSjHGh5fOri1/Pz4k1N+M9SQ1V6
         RWxA==
X-Gm-Message-State: AOJu0YxOwi8mynPGcJahzD0iuDWMgFDUsUDiI/gxH9qBvLds+jaWPJtw
	vXgyatdbrgpPR7wxatsoZpq/8MfkYfr5v8vWVmc9vk1vq+6U+sSDHoS2svfqSc/pHCDDPMLpUx3
	t0Hx0Cih/AONiiIGe+Owh0yZRGg==
X-Gm-Gg: ASbGncvE3TYGKMRRIHLNEuNDNIs2O5zvMzB/I8KXQ2yfdJo83D4mnMbh9goYcBnyAFG
	+9rzMgOBVonYf1gIA5JNsLYXDt62a+E42dRzDJwD6H7VJQZW+HNxhnyRqz2QGGBYmxqn4yE8U3z
	4T+rPPGBs=
X-Google-Smtp-Source: AGHT+IEfDkj+xRM70ZQhRY7trDn6+/8QWllMya5+UrW6Qo08Hp0Y7GikmPj3j6IIVXz+KogvdAmwG6a3qmgEA9DoI8Q=
X-Received: by 2002:a05:6402:3506:b0:5de:c9d0:672f with SMTP id
 4fb4d7f45d1cf-5e0b710711cmr12845853a12.16.1740403462847; Mon, 24 Feb 2025
 05:24:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1740400452.git.asml.silence@gmail.com> <fff93d9d08243284c5db5d546be766a82e85c130.1740400452.git.asml.silence@gmail.com>
In-Reply-To: <fff93d9d08243284c5db5d546be766a82e85c130.1740400452.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 24 Feb 2025 18:53:46 +0530
X-Gm-Features: AWEUYZnSB5ffW6J7PnQP484ebzbipB3lmZzlTOP553vO_HzC4hz7MLXhyH6f_5U
Message-ID: <CACzX3As=jqtb_C+K1JWoq2hAEYzWEzT_SRJ42yYNfT3soB3M0A@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] io_uring/net: use io_is_compat()
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"

Looks good:
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

