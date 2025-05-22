Return-Path: <io-uring+bounces-8086-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C73CAC0FE1
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 17:23:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A022F4E6B11
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 15:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B08F291144;
	Thu, 22 May 2025 15:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="DGEidXuC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B2F2980AC
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 15:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747927407; cv=none; b=rAEHS4wl4nXYIE0awhAWvA7ynownboMeiZl21O8i5K5kVB3stqqKYVbfqa2h4KLSoMfTq/C0GDZ+KovzK75sH4X8pWRYLVY7ZjTWo+tatC8IiYY37/AY+3Si7r0a77Sdc8RrL+ODMxJFDViArMlCqedmGHErI1rc9wkC4uBdjqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747927407; c=relaxed/simple;
	bh=pooPKGmFgT32vstUAPeBuZumUMpHcBloRuJ9TM6Yvio=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JEvn5eRyVI3/AeVj4SheLCPdGtRp/Z5G8Pv+isMOM7B8jMDzp87fG6dq6L1wk6vKkh7K8GdqDqVPW+Ha6qm3Y+rihxeO34EYZ+7/IUmj7RWdd5dspPbWodSUE2cqkJACeU7X7Xae3kbWlCyeL9Lsf8W0+mtECJg+w3EGnP9lITE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=DGEidXuC; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22e17b7173bso5132485ad.3
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 08:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747927404; x=1748532204; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pooPKGmFgT32vstUAPeBuZumUMpHcBloRuJ9TM6Yvio=;
        b=DGEidXuC1n7Ax8zm7raLQeBN7z+eOet4q4zy2H5v82vDlJY0KFTc8P/UpuFpmbUy6k
         pqz348HbpW7Ff2eb889lJg3H76hPAaIpknHHf+xT0h1guHHSCMnbMFJA/RRpFzM/V6dK
         /9eWbYjSslaAmL06RZ9Kq4sITM0nL84fhjPZ/u+iD2W4SvNYWWpXUrMUA+NFjh+/A6vc
         VwpRQu1PoPjYQEMXKwJi1xTtOb+k3YudKURNSQtHdLwdP7uQr/oZMU9fQHzF+cEIB0Et
         CWTsrQG0AJrJReblelakJkTbYyOzTN4It4xJbf/qS7V2469OMj4Qm/PGFkU6ls/AF+oF
         Bdbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747927404; x=1748532204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pooPKGmFgT32vstUAPeBuZumUMpHcBloRuJ9TM6Yvio=;
        b=hHh6osjCP4Lr6hkZvRPKR/be8sab3Y0RZ9XAlj5u1X61iYqysCDdmnQZY0GaL7lL+Y
         /BXbhF774ZyFHEqVzmAwTgHWZcQpzPpY2hWyDKbljo5s/AX7cp4ha4u4iqeYg63P8pA4
         yTH7qLyk5E2ttJ6awy3CW7PKjzI2KirN85wyEvJszz3/bSvPoGm//86nAI41PJ+ELq3v
         NxNhp9xqhkWk12TDERXkeKnkizkkMSqiYcBo3cANS0rFDssMmqQpDMSlh7swerPhwY9r
         PRT5vxNeLjK4/5efaznt4s3VlHJX4yk2241Rauu7TeffaQv+WR/s7sNdVnzxfkEHZB/X
         STOg==
X-Forwarded-Encrypted: i=1; AJvYcCVrqVqmN/FAM0AcyFNhSAl8uz5kSY0nxXzHV2UjSFeNYv7L1R3bcntkqfktiUp7EAoAYygAmY33CQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4jVMgSBVjk1S3rZ1pxCx4pIdkNMrylTtSim6OaZsnJydrxMpC
	uC2YMJO9XKLCsWT2N6hgPqYu21BTOd7bQsV4VSkywcu8/AR8vGRAdaww8QTjy+eBCpPjTSY+sz5
	S5Bqxu0xWTe1BMoV4dh53p01J+viRdypNEt8ZtEK4RQ==
X-Gm-Gg: ASbGncuhgrEHHl0BuI3frJ67d9gklzVCF6974zRJnewE/EQL+Rfqz7BitFW1kClP1Qs
	ikCYAIfPL8Tw1Mq+r6UdM5X8ALzqbIp9zRoyxhzRB2QlkmNN+qQ4Fb9D2ooD/nd8c/0EKfOwcTP
	8C4vL6/7ip09L+6J6z4lvaUq8dNRat+Fo=
X-Google-Smtp-Source: AGHT+IFyJDkLhc3vcy/BkkkKyj7LUOHhUvPrXG04fQZCkfixg46SzBPmIn4NlKtgD3+PCK3EqhEl42Pkl86ab43KLZM=
X-Received: by 2002:a17:902:ce01:b0:215:b75f:a1d8 with SMTP id
 d9443c01a7336-231d43881e2mr141147795ad.2.1747927403816; Thu, 22 May 2025
 08:23:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522152043.399824-1-ming.lei@redhat.com> <20250522152043.399824-2-ming.lei@redhat.com>
In-Reply-To: <20250522152043.399824-2-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 22 May 2025 08:23:11 -0700
X-Gm-Features: AX0GCFuTunneohC4OzPu3tT8GL3OuC9BtrUxGwfw2AHvQyRpNkqkF3TPhlR9PS8
Message-ID: <CADUfDZof9s1sOJjNRvaAi4xJaq0LNui0NST526+XQV6pcvz9uA@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] io_uring: add helper io_uring_cmd_ctx_handle()
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	Uday Shankar <ushankar@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2025 at 8:20=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> Add helper io_uring_cmd_ctx_handle() for driver to track per-context
> resource, such as registered kernel io buffer.
>
> Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

