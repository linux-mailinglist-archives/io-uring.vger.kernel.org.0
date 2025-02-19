Return-Path: <io-uring+bounces-6548-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B5983A3AFE3
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 04:04:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C745818927CC
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 03:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 489A485C5E;
	Wed, 19 Feb 2025 03:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fIJvZ5Hc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809EF35977
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 03:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739934292; cv=none; b=Lk7gtYmvqN8LDRU5vbZzgJz0OI5v4sy/HXmrZWmAg+eMpxetq8BG0mswGI1iT/gJNQB6KOsBljTTeG4NQcL4d494gNmftg9WGUI4Ct0rAOru0YrpeoTMVwyiHM/0BvimVptx9qb/ecYcyEV40xilLKSSyAvHh8rKYPQEQJ04Rq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739934292; c=relaxed/simple;
	bh=QBu8bnVp7cAAz8xvHD4+V+gCVvlmoZ7hW0/gQcIXuEk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cxSpf7aIJsWv35jDBdVyXrB4ZYz1BB432h1WnBdrO7eHjbc9JKbXzd1sXl95BjK0Yf9JukOEhpuhX09FxdF7YKXsqCfRDhKOny5MTHfiWcr72/LLJG+0MCA09DKzZNwws/J6eF0wS9333ZCBEVTWJ5CDii+g7QN0hlzTP3EI0LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fIJvZ5Hc; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2f7d35de32dso1411446a91.3
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 19:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739934290; x=1740539090; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QBu8bnVp7cAAz8xvHD4+V+gCVvlmoZ7hW0/gQcIXuEk=;
        b=fIJvZ5Hc35+fnDgvhNxNaqctehBa0ApLT/cwuw/95p1SIPny6321d55fEc1I4GE9qg
         DYnzCmb226iRiTFxW2bc5jC0o5dCcCYI5sk19Gwi/tlUZSzrC7qwMHQytATwy5zBHydq
         gnp4PWDcKmAdGJWC2Uy/5C/IBkrNHYhsUIwsjAgT7jsfTB9rcjM0qQLA3SjHW7OqBtxh
         dlHFOAxC8Ab1s/WF4jjCNRPuIZX8zT5+XPTKhE31KGkyIxaZihfS6ld2EFVJPL1EsHc0
         hPEbmz1LuFyVc/P85RqjeT26pepAJrH88LZ2Ik8ywtz7KWLFLhYrAAJ4nxVcfdpJJWku
         Vwww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739934290; x=1740539090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QBu8bnVp7cAAz8xvHD4+V+gCVvlmoZ7hW0/gQcIXuEk=;
        b=J41Gor7bIN84PKj7DLi/Mig6O3bsQ6z85i1ChjrgMrTGjIM79N3HQVp3+5lTbiEOUt
         qH44ttO+NlIVzPSzNiixIkk0HyTYRLTpCfuOMZ85hWpI0UlcMQnuZcmzY2S0zSuWOAm3
         0qoNnMwKpJ3Ea4i6cl9qx5liFkOBbiGisajh1/UamgBIQfTjfh7ZOqkj5nhoiAUJl7QL
         K6LYmrzV6shXlJVj5LNuhnAjLvjXMNlWr6t2mN7qicAww4YXRWFokKF2QmgNdEYZXvbX
         2A4ifcj8/fjcJuUFKhqhsJK1sBvHGh7azzbCLXFsl1nYFfRwYRm0n513gPs7/BY6YVf4
         CC/w==
X-Forwarded-Encrypted: i=1; AJvYcCU+sS21o+PJBTrD/d2mh3GknMOvGNa7PwDdNX/ovk2U59Q139M/ADJkZBhLa4TPrYZGcW3OzeMyOA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzeq3AaUUBzo7OZCQHxb1TxznWAIX2Wzz31qRCEfji4nA4IxCJ7
	kBRMiioa1a3IaWfaVS4/gNS+1ltnLLzRfXLARDLXkV7TC7wxeoZfewkHItooNB+mq16WEUnFAFR
	8jlYt5Iu3ykDeIJ0rQjmIwmriKpTLqYkrvpYDuw==
X-Gm-Gg: ASbGncvBfcoYHt8QBeEfeAo6w0XeUQQVA0KPIiTM01uj45KrJwbhdMDryJaUZSurDIt
	bbld+OGkcWEOrnNy01H25SePcQD8T/U+hK7PRwXdQK2WKG3vajtKU0OSbgYDO7VDCPlrzx2c=
X-Google-Smtp-Source: AGHT+IGbWfBTv3bJQBkLTddEsKSVQYYxX+1v0Zon0lOuA5Y7+jEcvxKlg5Z3EeTmqk6WIAlhUNG48r2zK9MjVfqGcQg=
X-Received: by 2002:a17:90b:33c6:b0:2fb:f9de:94ac with SMTP id
 98e67ed59e1d1-2fc41173a82mr9136423a91.7.1739934289773; Tue, 18 Feb 2025
 19:04:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218224229.837848-1-kbusch@meta.com> <20250218224229.837848-5-kbusch@meta.com>
In-Reply-To: <20250218224229.837848-5-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 18 Feb 2025 19:04:37 -0800
X-Gm-Features: AWEUYZlhpbl6zo51XLc-9LNMQhJtbstaAczwolRE4Vr2WBmTwGh9LK-vpcwr_Lo
Message-ID: <CADUfDZp0Q+Dg5jOhDpOAXpmPxcywS6TKajTgw95qZdAaZgn2sA@mail.gmail.com>
Subject: Re: [PATCHv4 4/5] io_uring: add abstraction for buf_table rsrc data
To: Keith Busch <kbusch@meta.com>
Cc: ming.lei@redhat.com, asml.silence@gmail.com, axboe@kernel.dk, 
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2025 at 2:43=E2=80=AFPM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Keith Busch <kbusch@kernel.org>
>
> We'll need to add more fields specific to the registered buffers, so
> make a layer for it now. No functional change in this patch.
>
> Signed-off-by: Keith Busch <kbusch@kernel.org>

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

