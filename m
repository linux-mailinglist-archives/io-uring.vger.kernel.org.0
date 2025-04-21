Return-Path: <io-uring+bounces-7587-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37CCCA94B17
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 04:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68B19167FCD
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 02:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E109D53C;
	Mon, 21 Apr 2025 02:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GsX6ypV4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0F81ADC93
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 02:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745203144; cv=none; b=R2kyPKk4z8RZda3AgkHM05q3PDGg8Qa+IiTReiJBidKVBIN4c3qcASOaVUtZa2JD6la9OsE55e7jg6KKmsmZnjgG6eWUTNKkNcEewn46ZSYXcj5JGivbd41i9JYzlwdc2ceHc0jnpdkUog7rlLkj/CDF2PZwy8SFMDM2T5gZrmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745203144; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HM2M68tbB7aUAV70+V/SYGT/B2AfIw6oDOwmRhXmswNy3QPGmr9N+IByzF4krdynP2gPFaipxTwZZW8fY3M+UBXZLwkJhySNvfYBPVqRxnTBBg5we+1Z1ZKzZOFk9uIYcvZb11WjTCluAd2+Zv4oIdz7G5D1/Z3FpA41puhK550=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GsX6ypV4; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5f62ef3c383so3731433a12.2
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 19:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745203139; x=1745807939; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=GsX6ypV4epbKpy2HTZYYTDhR347U6kRrSAIuz53o3Sc3cTUFZPXGPjAA8TenbNlRdL
         +sx/7Hr6alocXlAkHxBuDqjooR2pr18xsyHzkKr5tahRASWz+5OnVmhiyltpQaZNu/XB
         H1EeM36R5RgYNmYmQ9vwzZ81W/mJZVNPZEyREJ31ccU/XTNsq1XAQXhWKMulHNyUP8T7
         1j6uB8FZkCWFFaarizvcwKaVuKfygKTRPXt7KwXU0oiaR7rWyKbmfBGpXKpaq9vwH9mq
         iznSPX9xU6x4Oix2PoCTdQVpr5rbgHtGDnMMT9tKMHOhqkls1oVlJlLoso3VowQNfk1z
         23Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745203139; x=1745807939;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=BFzlpERILqGlxmfnCVIFpoS1wpW+TJh7DE1xG7PkgM5/QcyrOPdxZX+6xiKwlrEA9z
         JvK1xDUQ4oUZ4QCnL+HeBh4Ku5w/LqjxcC+s8IJ7roI7UHV833ROD25pRACnPfv7lecu
         KYvtd7iXd0rnPN8wmAUZS6o5Seo0+vdgAiPYJHYkmZURH7zVITIPnaXGSqYmULFR8x6Q
         fub/gSJrnNxMiTm47fj6Xe59n9G6UPenp/CIMGkA9Ufp1vHwXvM+vCCk0V5fwnyP1Uzk
         g6pO9bzQpoPwv6zARB3tEwajYVIdzAhU3hdb8/ZY/hmYwc8BVpeErMWEJ4f+zAZb1Gvt
         5tdQ==
X-Gm-Message-State: AOJu0YzMfp+pO//qUjd/i65/BQt2qqaqBSmTpqIJ3QZzMCFRja9+Y0qM
	GA2y3cUUmqoUUMsgzS8apJYMhJbVTis+r7OgsS3eKeILNovdrttkDIhFT6VwZDwk90/PFinj61x
	pCeNUvudzmg3A4PZU+V8UyKmCZw==
X-Gm-Gg: ASbGncug7xkKmByQkazISskro/IjiFAJPzB1yU5keAjhrPrEHIZvRbmdlLxVwmhmu6Q
	5bzLaD7yVK3CXywADRjI+ZFHc1CTWA/LvbIcwvlkkp5slBJjMA0DDhCO+YqGjgjqvHZDn5ZoYIY
	cJD7MBjUnlWoobl4F/pVILDaW2JY+KYFXuHiu55EHkX0gRNC5yDzAXjpHWWGWZ8vQ=
X-Google-Smtp-Source: AGHT+IFM4xO/oeq1QSdDaaNDXP2emQ/TOOhQKjbzzjta/iVQwYLYH6OAOluq5eDU5FdZ+uawlO/Ks34x+SCJhg3H3Po=
X-Received: by 2002:a17:907:7d9f:b0:aca:cac8:1cf9 with SMTP id
 a640c23a62f3a-acb74b8ed72mr818436666b.33.1745203139387; Sun, 20 Apr 2025
 19:38:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1745083025.git.asml.silence@gmail.com> <ad698cddc1eadb3d92a7515e95bb13f79420323d.1745083025.git.asml.silence@gmail.com>
In-Reply-To: <ad698cddc1eadb3d92a7515e95bb13f79420323d.1745083025.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 21 Apr 2025 08:08:22 +0530
X-Gm-Features: ATxdqUGAdJStYdt3-TMDx9XmHf9ubKVPnUVBJ7c7BihxYBDV1EddWcNKk8HctQ8
Message-ID: <CACzX3Ave44aDLSUttN_bmQa9GfF2koXZ=OpswoM1txHPtzxezQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] io_uring/rsrc: clean up io_coalesce_buffer()
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

