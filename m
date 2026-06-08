Return-Path: <io-uring+bounces-13639-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id JqgNFp/WJmrjlQIAu9opvQ
	(envelope-from <io-uring+bounces-13639-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 16:50:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CBDAC65782C
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 16:50:06 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZpsPEESK;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13639-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13639-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 94F75317BA53
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2026 14:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4BE3D9699;
	Mon,  8 Jun 2026 14:25:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461CF3D9040
	for <io-uring@vger.kernel.org>; Mon,  8 Jun 2026 14:25:22 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780928723; cv=none; b=lOJZVCc6SDp905/qkYbMkpC8xnWs1rgbvOuqJ8wC1/q5rzREiJQirvUh/gn3BuIkVRZIORX7Lo8+EO0bJtRbYQn20r4AMu55UTjXRjzxqLTFdReUt0CpAaT4QBYXDng1FCQZw7zp1x9jSqRldvCYcf1sbKp32gyPZWD4TUU6P/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780928723; c=relaxed/simple;
	bh=nC/BIOCahSpxyfrAd9ICxSQeec7Mdys4GMubm5XO4fk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MSFDGY/IpBIRcbe+SphXBYfnfIg0d4O4OMogLQKUOzJFyno4/3s7a4GF6fbCxLO7WOM9Z9xnG3UUW0ZYLxmOx0fOeGxbiOQvZAOcN8J/f4bxqjVmHg3qzUE/6DNiEYiP87vrLy0n02Hph/2QZLlfFAShDZbtSGnHnNJWd82XWRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZpsPEESK; arc=none smtp.client-ip=74.125.224.51
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-66049669d78so3700774d50.0
        for <io-uring@vger.kernel.org>; Mon, 08 Jun 2026 07:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780928721; x=1781533521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qjFJ6f4nVXUXcJ7ItoX9ERLnHKS1EUmGqynEHbOX2+4=;
        b=ZpsPEESKMWzc9gNcLrGNGdmHokq9uoJxjy4z1X1Q7NEsk6G2tTzQ6lfPKA0WZXDn/b
         J8MrMWvDhFDDEEH/63ipFSbixnBXp04q8yUcJK3oZnKphsGwHY6HP+/zM7B1PlK4ydNn
         hXynj8pz66cVnKbMxeZj5umG7E7ccDYn1YZNmLLOmhZKySXRt+c6WgiwxwoynxC5EC6H
         lQcLKgQPKzNgbbr1MfcOlA4oIpVcF2UUr0F5TxXyzzfR/xh7xxDI2lS78iAd+syVLrj7
         6FEHY9Dk/3M0xNL2LlhymNZycKirv7KjPkF46HI77c1GRH3uUVx9ZmEyDJ0pbedXjsf6
         bSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780928721; x=1781533521;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjFJ6f4nVXUXcJ7ItoX9ERLnHKS1EUmGqynEHbOX2+4=;
        b=ctzv9wZB3+oSzCGeaLbIHsUdC2Q619TSP+kuq9vvPYLDTKa63xRHmjOqYf5BfHl7u5
         Gjj8oCNvTck3BPqszpJhdHWPpBU5uP51ERtGBbUgjnNmKXlb97GfwDl3idGvtQpS8TdU
         ic631KqxKNr0FdTfcLfCddIwSpsQdHzeJjVwGMzE5xvdsoO5aKiy++6sdlzXH/U6e3mN
         h3ZYGcnw0TQ9yF5QELi0riXc74E9mmLzC4y0wVwFI7K1P2WfIshiIP/RaLKeD2OpVJt9
         EpH9CiwIAAlDX2RAWtT3qbR6dp0n6spb0LFMQo8/WMMOrZ8Ytb7QvJjaQVa1lD62E00w
         35NA==
X-Forwarded-Encrypted: i=1; AFNElJ9ZiX4MY3IHWrzAf9Ep3/8WGJy88P27KUOtwFgfPSmc+BgfHSqVQ4TDzv+EjptzX9ZkzQtB0ZOeoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi3dN+p1WgqBIU594d950VV11iM2xDra13k1ipButKtwUYyXDK
	EuM2c46O/ELApcP/A875SiWZl242E7+AF4kRRIxeKFVrtoDoOXLku0X2
X-Gm-Gg: Acq92OGgiqWjMt75AmFYHkFw+uYYTpYzm3sXv8u0Mks1QQkUOo+H7VSO3L4JKjIzTfV
	1zuXInFBGblV8pXnQvJx8jHRel1XfcU77VtV4MJtX70QQcV4BOdxuCsEtRR5z5V2k3OxCjH24n4
	7rPkmGi8Qk+zVhDdcVYyQMyyk2TUadOK59M0dXldfV4vjSLeXDk++aG6s871bbOPztDbOLIKweQ
	ZLVjIVHFXSER909rK77YTxcKKDkg84DzQUmlYL/IbR/oym6r3MTdD2D8RaQ+LJ+vAd4Ygf9IT60
	Y3Z/E2j8T2SpLsN7GUt7dVfQAgeaHFzpcDWa0Ut1vXFz6H7FYLdOl+mEPbk0jNmxWp1hyoR36Gc
	ma6gl5xsO6yIeZDm8SxLUoa4mUbxwD/CMHExrny5DQi14DCS92R2zdk6mOyMsbgZlbPRw8HxEJ7
	QsKcYefd7Uugq6xVtJdVLwqnZNMxBUaWl1ezgrBx5AAjSuQJBAjgS1lNgwBYhsm8tC/YmggA+1z
	I+eeNfdQGxQxSZOlIRGDgYjOXrkpYusnpTe7RtbnOWNnOZxx80+8m7VXeoyB9Df
X-Received: by 2002:a05:690e:d59:b0:660:e35e:abfe with SMTP id 956f58d0204a3-661070710eamr13902017d50.46.1780928721197;
        Mon, 08 Jun 2026 07:25:21 -0700 (PDT)
Received: from fedora.tail348456.ts.net ([172.245.82.59])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-661473db74asm239368d50.7.2026.06.08.07.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 07:25:20 -0700 (PDT)
From: Ming Lei <tom.leiming@gmail.com>
X-Google-Original-From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 0/2] io_uring/net: support registered buffer for plain send and recv
Date: Mon,  8 Jun 2026 09:25:09 -0500
Message-ID: <20260608142511.659240-1-ming.lei@redhat.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13639-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:tom.leiming@gmail.com,m:tomleiming@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CBDAC65782C

From: Ming Lei <tom.leiming@gmail.com>

Hi,

This series wires IORING_RECVSEND_FIXED_BUF into the plain IORING_OP_SEND
and IORING_OP_RECV paths; so far the flag has only been honoured on the
SEND_ZC path.

Motivation: targets such as ublk's NBD backend want to push/pull I/O data
directly to/from an io_uring registered buffer over a plain send/recv on a
TCP socket, avoiding the per-I/O import and page pinning while keeping
single-CQE completion. The SEND_ZC path is left untouched.

Patch 1 is the kernel change. Patch 2 adds a liburing test and is meant for
the liburing tree.

Changes since v1:
 - Reject IORING_SEND_VECTORIZED on the plain IORING_OP_SEND fixed-buffer
   path: the plain io_send() issue path imports a single registered buffer
   and has no vectorized-regbuf import step, so the combination silently
   did nothing before. (Jens Axboe)
 - Add the matching send-vectorized negative case to the liburing test.
 - Clarify in the commit log that SEND_ZC is unaffected.

v1: https://lore.kernel.org/io-uring/20260601095853.3670199-1-ming.lei@redhat.com/

Ming Lei (2):
  io_uring/net: support registered buffer for plain send and recv
  test: add fixed-buf-send-recv for registered buffer send/recv

 io_uring/net.c             |  47 ++++++-
 test/Makefile              |   1 +
 test/fixed-buf-send-recv.c | 311 +++++++++++++++++++++++++++++++++++++
 3 files changed, 357 insertions(+), 2 deletions(-)

--
2.54.0


