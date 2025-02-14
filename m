Return-Path: <io-uring+bounces-6448-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC892A36717
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 21:49:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FEDE1890B2B
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 20:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EAD5192B65;
	Fri, 14 Feb 2025 20:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="cNNIzhYG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945C118EFD4
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 20:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739566176; cv=none; b=Y3e6h/IHyr5b7db2JHYUw07a1gtxX6gJfUbMnz56jkVUTXSy//x63cRwrxUwERnTtJKTEiXhMlqNDKVUW9qLL+EiN2ehXuhVLF4yDnGnf4pK3eNQxlbJO0rwDobPrU7c92WChfPWEA+RvSqbFx7FX5clWF7aew5TBCxOK3R+YMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739566176; c=relaxed/simple;
	bh=7zPquDCtZyzOA5PY0kmGl8Aq5WV/QI7GoaYVVezsWQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/oM3Zk5Z/qQRvBDIjMm57aHpVPnn6DZEvRaQvWLtO6QKr1SQL6F7AhvMqfR+WHGN5woVuR/8go1qQ+rIxEeP4J2Hx793nz4CQXjsdVQowxdS4HiFkD1mMqR8cTimMsWbv3UrrrZfIdFC4OW3XMcywW5EefOWip8sbJ4gR6ME5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=cNNIzhYG; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-21f55fbb72bso47648335ad.2
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 12:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739566174; x=1740170974; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7zPquDCtZyzOA5PY0kmGl8Aq5WV/QI7GoaYVVezsWQc=;
        b=cNNIzhYGPt77GZ9dhZeSuIZ/XhFVc8cx6hfaLMOuxGn3PNxARYGdxljdN3YORgxsCf
         xknYqHvW65yDx0hCYc2UkE42YTYpXlUW3oVkBFipeg9D6JjZu08oKyZTIVAKi5UV2i6u
         FEllPwZLZPCf4HdMUgITIzh82+bGnvvbaQAP6hhw+rmbMTRrw40ssZQhvi53JPR12FQv
         beMRdlnG/nesOKEs8CW9/g95MRnPmF9znsElm5xLqvDq4lgidMOnXnwCRgeSwKVKnPU9
         2Es2WWtbSQBrk2pVRSYwssywGwTXRSarqd7O0zh7SUBBpm9WdkrDiLqbiqUcXJwuWnM3
         uRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739566174; x=1740170974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7zPquDCtZyzOA5PY0kmGl8Aq5WV/QI7GoaYVVezsWQc=;
        b=liegZ1+F4Axz+68++21aqWY5eOhWNY/E1W6nJ8WJ+nO5MJk+4/69Qnq8Aj3BfCgBdU
         GKqbVcJEQ4jB5wKnpfpvwE2ys+wB+seJSRw+r0eUK7xL81m4VyQjJXuv7SX5v6idQJWX
         brIrXTtTyc5FJu28eIpJDheiKAj673NTT/SpOBOJ5H2X5VXyXt7ZwchztGuusWzM8N7r
         dp1HoDdMcKLqIJrjXQ3swznLUkOE47oizLrkeDOwf0vCF3HBwos6KzI4Jp3wE+Z/rw+f
         btWCPFkCwIb0GIjpY+ZqcMUYLVv68f1wtW55JxbKHtm46+LlTYolfoGk5PHQhfCx4vsz
         zOww==
X-Gm-Message-State: AOJu0YxsEVMd65UCi34yH0N1dnXRsjvJEPnrLAIkSz+dWiLM9Srv70uG
	bqk/8rsbnIx/mvRHjwQ2DcO9E9g+aQO3Azkezy1H9gwSfj4vGwRuYpIklpVct5fnVH2P83EfGTZ
	Z2iZ2+IrEpFqQ6CTOFUmfkKrJ0ZbSRxL5
X-Gm-Gg: ASbGncubJOlJ3Tc9jboiMGVV4wszOobztIhHkbPoX6bpbjrhWTrbqMAhtvMVT17rpDO
	6tCD5z+/YI57yJdrLS21vG5rlo+Q6gNpwFQ4VAoFZavJgQ34Az/AzK/d9CaI+EEhOKQ3hLz9NFs
	nVuia9PY2uhET+yv3jNcb9kqTVx1g+Gj+r9zJleHuz2XumNXTZF7HH2PAWP/74KoOJN5O8PE0fD
	N1lBnA0GVd1+FU3+Y9OfyZ9IlBlWe7s+gl0aT2QRtyWAtYR8qmQ/fZAp4T7mneDkXUM4BkzCm86
	s3sTv1wfbrTy5p/z94+9VDeTnJJCwh0mh6VgH7g=
X-Google-Smtp-Source: AGHT+IFuL28bar/QQRuxMTylOWiwwLCM/i7AeDLN31AxjVBPKQbZV8sVgNBt8HB20LMEdqUOzmolYc/wrkZM
X-Received: by 2002:a05:6a21:6d86:b0:1ee:1c5b:9d7 with SMTP id adf61e73a8af0-1ee8cb4b58dmr1477311637.25.1739566173837;
        Fri, 14 Feb 2025 12:49:33 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-732427650edsm283706b3a.21.2025.02.14.12.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 12:49:33 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com (dev-ushankar.dev.purestorage.com [10.7.70.36])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 22F813403B9;
	Fri, 14 Feb 2025 13:49:33 -0700 (MST)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
	id 14433E41399; Fri, 14 Feb 2025 13:49:33 -0700 (MST)
Date: Fri, 14 Feb 2025 13:49:33 -0700
From: Uday Shankar <ushankar@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH v2] io-wq: backoff when retrying worker creation
Message-ID: <Z6+sXQrSYRyGEScf@dev-ushankar.dev.purestorage.com>
References: <20250208-wq_retry-v2-1-4f6f5041d303@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250208-wq_retry-v2-1-4f6f5041d303@purestorage.com>

ping

