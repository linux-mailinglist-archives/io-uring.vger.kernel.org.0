Return-Path: <io-uring+bounces-12410-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UJDfOtbFnmkuXQQAu9opvQ
	(envelope-from <io-uring+bounces-12410-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 10:50:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6250C1954F8
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 10:50:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D444C3013B47
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 09:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070AE2C08AB;
	Wed, 25 Feb 2026 09:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BSjE7YXh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KoMl7KZN"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD06038F233
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 09:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772012612; cv=none; b=WsxvshDUWPkoxC7A1Ic6VIiPZjIcict9wV772M6Kgc29O7/ep6OdpNTWrrtl14EOS0DNIS9EOVoR0/sAQXCilxXITIjoUsYo2Gp1R+wOtTlCL5nZh9iiHo2sx9pyYtllgZhzAvrI4ox6cGF4+QqY6aQWsDfddl3V08dv1GBnKJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772012612; c=relaxed/simple;
	bh=dJBC8mLDABEEc1VlJb5lfgoDrRuha1EpEiY4jlkAt8U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=q7B4E/zxoqmc7pTZAneWG7BXHXdXptI4+NgsXSsopMXBRas86bi92dq1JJYBH7p5QIIhnkQoIxyAnkS7DFMfVTyopqsWUIIIxYz4WqlO6jUpEVzl3Mby//34HYx4qhwFszzLN+n0D+9hAj/+1FhYfVwh2/+de80ZqD0e/8BG1Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BSjE7YXh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KoMl7KZN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772012610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dJBC8mLDABEEc1VlJb5lfgoDrRuha1EpEiY4jlkAt8U=;
	b=BSjE7YXhUTHmAF8fWvxzw2Muw4ag9kFuImifmLbEmVLjGDmwI+gLZlYMbFF5Q8D1UHAoo4
	hm873NDmneXzW+2MnCPLHELtwFHQ7HEH780lEJq/iqAuNhVA1t3ObH5NSg4N+r+My6fOfA
	+ltxCvgnjrQXRqts/uFv+nQmnNAZONQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-uojZt56ZMl2LCpZrpiRiXg-1; Wed, 25 Feb 2026 04:43:29 -0500
X-MC-Unique: uojZt56ZMl2LCpZrpiRiXg-1
X-Mimecast-MFC-AGG-ID: uojZt56ZMl2LCpZrpiRiXg_1772012608
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4836b7fbf4fso56297225e9.2
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 01:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772012608; x=1772617408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dJBC8mLDABEEc1VlJb5lfgoDrRuha1EpEiY4jlkAt8U=;
        b=KoMl7KZNMKRGFlR55s5YCU5dmbxj0YLXiZqQ3iA6Za00ccoF6Hqcst/frmVGq2259D
         B0oEbu1rpqdWDzSljKSXfJ7fPvhN7oFzSZkigNlaqMU4qM0J86aUIcVHT/4bcx0+2rBd
         rith62M3/jHcLWm0ItZuggcwPGXmTFQtQoNrTZCCWsXedOC0RKbCSwnF3SZQhmdIqJfu
         3fW549yI8HrDgFnlpOVer8d7gVppOTOBs3WE3hmbbpZUZwhRC+wx5iTVYHlGpYp7o61b
         7dWuCcxQ+ZO5g+0ox2QFDRSZGe+0KRpTxycu0Hb370Sx6Tz6eOw+scMpPGWS3tZS8Ti7
         9c6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772012608; x=1772617408;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dJBC8mLDABEEc1VlJb5lfgoDrRuha1EpEiY4jlkAt8U=;
        b=YG1VdKhHJAhJ+RG2ohvFnrQSzpE29BL5UPhLZjQAgTrm89AZmWRU+nwSswgAp7ASO8
         BgwMhE/WtltT5wPieebcd3JYLSNnJYkbocg8B1JZHT37xQ9eu6ImsINUML3Xh9bThVLI
         J1y+iBXrDAEYaCZEImoKnrc9inFZoVd0eLum1CRHpHBaJUKdsKTnYDSDHOL4EMr5qYOr
         Laex2AANrXsKWcuLXZ6BHHVzUKU8dVM7Vm18PAXDbtLe4MH2oaCpjcQG8RYUqhQOQZJ6
         uDS1Wq3y5fNwbRI0UTLtEDVZ91W65UlbQC0KGtWOr4Nf7d73JNHv02FJVti7kyFjIm0M
         eUuA==
X-Forwarded-Encrypted: i=1; AJvYcCUSgoKD/EGdiMMer19HIwIng6lML4GFrKPZ4m8HbVgRrP4Tko7jWacWUVxVLgf20O4FEOX7oYWl/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxt/2JTNn0gpKK08s0ksfYCVSLCWs9bdVNiDAFzVeSw82+h9Vqh
	Jd0sCwbRfWsBd6hqj+Kfvd+Ci3/ZTwhToMtnTjSXz8oIUNj8oPpJt96UooSHAM4JRhn5Vxu1DJ2
	+XKYy0Um9ZX3Dpm7L+ONu1jir/hNfiIbTzSQgNJjgH42UD4zOnna1H3IxMEWK
X-Gm-Gg: ATEYQzxUjhitvLC1egUVzZae1rRHIeMuo0GNsAbnBPvuCasRAcjZwr6th5GYJ0AVPFS
	cxSFTHk9bikEV9/BC5GTWudbE1kj0/Lq8N/2xd3L1cAmH0IB+E2ITGDLCDTSgbVixiQpxfaQDNj
	sOkOcV8ebPZGc6fJOD7wiO5msiM107DtNsb+2fd6jrnkvQYPkVzduMpFZHsYSfn6cJoUkHeRd83
	SpwBUl4EVU3O9IN+zoJXBrD0gXFGaPI5oQQVPmSZLfh/TgH0uJprnYSYx+xJwkw1VblLYFsp2Op
	xWEscL6vwnviTNUiphDmKI0wkhrxubLq+m6AzXQzZJevV54HIFPyHbjoaUYaW+7AeOy7SKUn6GO
	Hp9fjp87oKModdOeldLYhNYLPhP2jqo0n2UCX2E39cxeaW3pZ
X-Received: by 2002:a05:600c:8287:b0:480:3a71:92b2 with SMTP id 5b1f17b1804b1-483a95eab99mr223255665e9.26.1772012608013;
        Wed, 25 Feb 2026 01:43:28 -0800 (PST)
X-Received: by 2002:a05:600c:8287:b0:480:3a71:92b2 with SMTP id 5b1f17b1804b1-483a95eab99mr223255025e9.26.1772012607592;
        Wed, 25 Feb 2026 01:43:27 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.borgediget.toke.dk. [2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfb85c58sm8490385e9.9.2026.02.25.01.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 01:43:26 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 7DC33516AE5; Wed, 25 Feb 2026 10:43:28 +0100 (CET)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Byungchul Park <byungchul@sk.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, hawk@kernel.org,
 andrew+netdev@lunn.ch, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, ziy@nvidia.com,
 willy@infradead.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 asml.silence@gmail.com, axboe@kernel.dk, ncardwell@google.com,
 kuniyu@google.com, dsahern@kernel.org, almasrymina@google.com,
 sdf@fomichev.me, dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com,
 shivajikant@google.com, io-uring@vger.kernel.org
Subject: Re: [RESEND PATCH net-next] netmem: remove the pp fields from net_iov
In-Reply-To: <20260224061424.11219-1-byungchul@sk.com>
References: <20260224061424.11219-1-byungchul@sk.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Wed, 25 Feb 2026 10:43:28 +0100
Message-ID: <87fr6pma4f.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.04 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.63)[subject];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12410-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,kvack.org,skhynix.com,oracle.com,kernel.org,lunn.ch,suse.cz,nvidia.com,infradead.org,davemloft.net,google.com,redhat.com,gmail.com,kernel.dk,fomichev.me,davidwei.uk];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toke.dk:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,sk.com:email];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[31];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[toke@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 6250C1954F8
X-Rspamd-Action: no action

Byungchul Park <byungchul@sk.com> writes:

> Now that the pp fields in net_iov have no users, remove them from
> net_iov and clean up.
>
> Signed-off-by: Byungchul Park <byungchul@sk.com>

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>


