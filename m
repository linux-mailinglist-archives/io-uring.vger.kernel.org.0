Return-Path: <io-uring+bounces-13317-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJYvFHMGBWpRRgIAu9opvQ
	(envelope-from <io-uring+bounces-13317-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 01:17:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BF8A453BE25
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 01:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 257293070D88
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 23:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAE2B390990;
	Wed, 13 May 2026 23:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pk0G3UZe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598E63659E8
	for <io-uring@vger.kernel.org>; Wed, 13 May 2026 23:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778714116; cv=pass; b=j5J3Sc+Jtsn4dppP4kfG+IXv6lDnVDvdQ9qsXHLX32mOI8meSW6XnMXVD3vhqf81O3FR3inxVYRD3Mog2uptTMUuuUMul8nOqbn7qrXG/aZGEVx9gpzMW0KJi75hptnrjCSKnBh0halJGyvO+9TeZVbPvfJPSpPfZOXCCR908+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778714116; c=relaxed/simple;
	bh=Cvi3kuhUW4HbQ9TOf5HXDLzYujlaZX8mHgi1hLQCITw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=uJd4t6UJe0p44niYH4S4axD6oBF91jRDLo94N44nLJseTo9pejuup8jON25NggdOW/DHCFEBMFes8p5Ua7vTiaEKkDGGaM7kPOnagHBtqTdDWWsiQVng+eaWe6wX4/pL4bt4pFgH3ewfkqHLGi3VvrzMX9h37MpGfDNSKuqBfto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pk0G3UZe; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-64d5a7926cfso7373375d50.2
        for <io-uring@vger.kernel.org>; Wed, 13 May 2026 16:15:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778714114; cv=none;
        d=google.com; s=arc-20240605;
        b=TvP+EqXxS0U4bCZ6Y2qoxvT93A+FL1avWrxTlhlOG1sHMA+dxkAUBH7WrqOA3EMvpp
         CTOAzYdeYRl1Zt/TfXQ/kGR6e9iOIRBgKgauIqa+XZTAyCGnFq5byT7grJmK4U+mFpwb
         bKEQNZMImBX4J3DsK88m3TpxAWVDSWy6R6I1k/Iq21LG7CEow7pgyQi1MDtM4COIiOYl
         nLKHaPuEClRyR2QsdE7+DP8cwuXyG4FFaEE9c1WD9T2IQLmZFxP1brv9pF4vdchOAQjV
         fcY1DRMn8aqreCOvEzwovF9YSWwXB5cRyGJL0CfGrKw9F3bkYAQhCUQQPt/8+S1YZN81
         1L6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=7jUpfli+5gLA66CkrC+jUuxta3z8LiJy1WxsIljE13E=;
        fh=wLn5EUEGo6D98igoLw87CsAt1BGbbr+kDYym9ZfMRag=;
        b=UHSF424XgDZO1+S3zY8eqNuknA565oCVdKE7sJbHPNvlMzJm4Qd96OQbkea0mV7SCn
         Fw+snyOrlnSjmNR0qey0Y3/1BDEeaudMpHxonbxUnu1JjPglxnUiIXfxMvpM7oW7rl0e
         T5520W+hGvTvrLzN4jEkhxaAlLRe7ouI0HnUICgdEi8rNbx4djaARd/ZKC78oJIhkWlt
         OBBOrMZL1FERUJb/4ReTiK5ZmzJD9acjCcU9uccYZe/G9eMtIpPUKfit0EA/+1LcYlhb
         fHwS7rp14tPZNmv5GmSyXGfAft47NGPm7e4HdqX2p042WNC+iI1ufvLDmYgM4Al9vAmG
         7f+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778714114; x=1779318914; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7jUpfli+5gLA66CkrC+jUuxta3z8LiJy1WxsIljE13E=;
        b=pk0G3UZep4Ud94+SgiLN8SydWW4MMeqq5jtnrxkLq0uvq+aDq6nJ/Yt6Cmx2NpUGCQ
         VnK0l8A2ZPPigc83riUQsxB/fkfDDpdkKrzWhSuSxyAIqBia6wgVEOkz81T7Xv858txY
         zGts2Qdw93ryX5eNhp4JFO09FhoWouMo+O2ZdnpGHCDO971f9Y3KTQpW5A6IDbAUUNAo
         PHKuuCV2DrS8wZ5cqYk0DE5R9MhiRJUEh8J0xuRY90kUxoZANm2RijpS5V/1rrfMadEM
         2Qd7fajYvGM+q7rWoyuhqz4JuZdQJ2BmJC+g66AlTZ4XZfFXsTHGWtvl6xEuQmu7z6HQ
         VMLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778714114; x=1779318914;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7jUpfli+5gLA66CkrC+jUuxta3z8LiJy1WxsIljE13E=;
        b=rA4+RAbxbGy2jZfx3kdyIWnx/xt1jbshpdud93uTYtp0Ve3hRHhTUasmPwkvjGSskr
         dD2ImCx6tVZW9wRx7PGqEUT+gtP7jl6iKelExuUm18qrxfEAQSlyWw0WNawpPfWZBQix
         9D+cVRYpFVWvJ2a/qdeVwDXXjtYxbmOiPb9/UrGTOtoHX28vpSZzdeaQgw7E8z7uTMuG
         gBtZYtOtqiwnR3DU1856FNweP0xYOfoKZ8Rlym5Equkwt9VMaVv9oXUTqDs01MExaYIN
         YIudvVQWOTUJm4wZ7KO0HFifkubu0JMm5DkwnZ7Fuodv7X1OW7Rr9zEiBctOfXZ1jVUo
         ywkg==
X-Gm-Message-State: AOJu0YxeXw2ZW0cID3WQBvjXG/Nwi961QmM7WI1U0/sP9eh5/X3pgMWn
	NEfFMxghWPikbZ+a5YtiT8lXIQfm4MuFAjRhnagYggDYccWl01aJyfLXXsSdWJRusrwSAA/cUIV
	1EO3N/6HaWYmHS5SCKkbRx1Gkpxhd58UWPEKK8e98
X-Gm-Gg: Acq92OEVjRQeGJG8s10wAbewGDfzRDqUMqJ+RdDHjjbw1a/uQZsuzNlDdH192W+LaZZ
	S5h9y/vWCPb2clZzJNXBzPY7TDSXSdU2exR/+J4QQH15tcNDljmwsx1DDFE2WCArespqdNUiXk3
	lAOA9rELbTSm5nB8DFKpR8OdZpxfJlkMMyrP9AF3k2v969V823onNH0MFFGLgogS2HyyBvpqHm/
	uhCpHUD/tkS7WA4RXeOtgpmnpQl2sHhcTh8jfVRCl347AAkVRLGZpUbepkM0TKIbnNXk2R4+/nk
	kZP2
X-Received: by 2002:a05:690e:bca:b0:658:d26:d8cf with SMTP id
 956f58d0204a3-65df815e1e2mr4901993d50.23.1778714114134; Wed, 13 May 2026
 16:15:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Oleg Sevostyanov <savant05@gmail.com>
Date: Thu, 14 May 2026 02:15:00 +0300
X-Gm-Features: AVHnY4JpF-lBgqcnrl3Fm5BiHr07ZWX_T0HCGoEYpWRv8Zn2R8FWmxRWi_zE97I
Message-ID: <CAJv4CsvbaJd5GoHjYPzi3bgEO0fPT-3xj+UV7JMhqTyh2qr5tg@mail.gmail.com>
Subject: [PATCH] io_uring/rsrc: use refcount_t for io_rsrc_node.refs
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000ee87a00651bb2600"
X-Rspamd-Queue-Id: BF8A453BE25
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,multipart/alternative,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13317-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:~,4:~];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com];
	RCPT_COUNT_THREE(0.00)[3];
	HAS_ATTACHMENT(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[savant05@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

--000000000000ee87a00651bb2600
Content-Type: multipart/alternative; boundary="000000000000ee879f0651bb26fe"

--000000000000ee879f0651bb26fe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

This patch converts the refs field in struct io_rsrc_node from plain
int to refcount_t.

Background
----------
During a static analysis pass of io_uring/rsrc.{c,h} I examined all
sites that touch io_rsrc_node.refs:

  - io_rsrc_node_alloc()     rsrc.c:147   initialises to 1
  - io_buf_node_lookup()     rsrc.c:1117  refs++ under io_ring_submit_lock
  - io_clone_buffers() x2    rsrc.c:1199  refs++ under uring_lock
(lockdep_assert_held
                             rsrc.c:1232  asserted on both ctx's)
  - io_put_rsrc_node()       rsrc.h:107   --refs under uring_lock

All four sites are correctly guarded by ctx->uring_lock, so there is no
present race or overflow risk.  This is a defence-in-depth change only.

Rationale
---------
io_mapped_ubuf (defined in the same header, rsrc.h:40) already uses
refcount_t for its own refs field.  Aligning io_rsrc_node to the same
convention:

  1. Gives lockless overflow/underflow detection "for free" on kernels
     built with REFCOUNT_FULL or on architectures that provide
     REFCOUNT_ARCH_OPTIMIZED (x86 since 4.14).

  2. Makes it harder for a future patch that removes or relaxes locking
     to silently introduce a refcount bug=E2=80=94the saturating behaviour =
of
     refcount_t would catch wraps and emit a WARN_ONCE before a
     use-after-free could occur.

  3. Self-documents the intent: the field is a reference counter, not an
     arbitrary signed integer.

The change is mechanical:

  int refs =3D 1           -> refcount_set(&node->refs, 1)
  node->refs++           -> refcount_inc(&node->refs)
  if (!--node->refs)     -> if (refcount_dec_and_test(&node->refs))

No functional change is intended.  I do not have a stable kernel build
environment that includes the full io_uring tree, so I am unable to
provide a Tested-by, but the patch compiles cleanly against the 6.8
source tree (io_uring/ sparse checkout).

Oleg Sevostyanov

--000000000000ee879f0651bb26fe
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<br><br>This patch converts the refs field in struct=
 io_rsrc_node from plain<br>int to refcount_t.<br><br>Background<br>-------=
---<br>During a static analysis pass of io_uring/rsrc.{c,h} I examined all<=
br>sites that touch io_rsrc_node.refs:<br><br>=C2=A0 - io_rsrc_node_alloc()=
 =C2=A0 =C2=A0 rsrc.c:147 =C2=A0 initialises to 1<br>=C2=A0 - io_buf_node_l=
ookup() =C2=A0 =C2=A0 rsrc.c:1117 =C2=A0refs++ under io_ring_submit_lock<br=
>=C2=A0 - io_clone_buffers() x2 =C2=A0 =C2=A0rsrc.c:1199 =C2=A0refs++ under=
 uring_lock (lockdep_assert_held<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rsrc.c:12=
32 =C2=A0asserted on both ctx&#39;s)<br>=C2=A0 - io_put_rsrc_node() =C2=A0 =
=C2=A0 =C2=A0 rsrc.h:107 =C2=A0 --refs under uring_lock<br><br>All four sit=
es are correctly guarded by ctx-&gt;uring_lock, so there is no<br>present r=
ace or overflow risk.=C2=A0 This is a defence-in-depth change only.<br><br>=
Rationale<br>---------<br>io_mapped_ubuf (defined in the same header, rsrc.=
h:40) already uses<br>refcount_t for its own refs field.=C2=A0 Aligning io_=
rsrc_node to the same<br>convention:<br><br>=C2=A0 1. Gives lockless overfl=
ow/underflow detection &quot;for free&quot; on kernels<br>=C2=A0 =C2=A0 =C2=
=A0built with REFCOUNT_FULL or on architectures that provide<br>=C2=A0 =C2=
=A0 =C2=A0REFCOUNT_ARCH_OPTIMIZED (x86 since 4.14).<br><br>=C2=A0 2. Makes =
it harder for a future patch that removes or relaxes locking<br>=C2=A0 =C2=
=A0 =C2=A0to silently introduce a refcount bug=E2=80=94the saturating behav=
iour of<br>=C2=A0 =C2=A0 =C2=A0refcount_t would catch wraps and emit a WARN=
_ONCE before a<br>=C2=A0 =C2=A0 =C2=A0use-after-free could occur.<br><br>=
=C2=A0 3. Self-documents the intent: the field is a reference counter, not =
an<br>=C2=A0 =C2=A0 =C2=A0arbitrary signed integer.<br><br>The change is me=
chanical:<br><br>=C2=A0 int refs =3D 1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -=
&gt; refcount_set(&amp;node-&gt;refs, 1)<br>=C2=A0 node-&gt;refs++ =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 -&gt; refcount_inc(&amp;node-&gt;refs)<br>=C2=
=A0 if (!--node-&gt;refs) =C2=A0 =C2=A0 -&gt; if (refcount_dec_and_test(&am=
p;node-&gt;refs))<br><br>No functional change is intended.=C2=A0 I do not h=
ave a stable kernel build<br>environment that includes the full io_uring tr=
ee, so I am unable to<br>provide a Tested-by, but the patch compiles cleanl=
y against the 6.8<br>source tree (io_uring/ sparse checkout).<br><br>Oleg S=
evostyanov</div>

--000000000000ee879f0651bb26fe--
--000000000000ee87a00651bb2600
Content-Type: application/octet-stream; 
	name="0001-io_uring-rsrc-use-refcount_t-for-io_rsrc_node.refs.patch"
Content-Disposition: attachment; 
	filename="0001-io_uring-rsrc-use-refcount_t-for-io_rsrc_node.refs.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mp4og0k60>
X-Attachment-Id: f_mp4og0k60

RnJvbTogT2xlZyBTZXZvc3R5YW5vdiAKRGF0ZTogVGh1LCAxNCBNYXkgMjAyNiAwMDowMDowMCAr
MDAwMApTdWJqZWN0OiBbUEFUQ0hdIGlvX3VyaW5nL3JzcmM6IHVzZSByZWZjb3VudF90IGZvciBp
b19yc3JjX25vZGUucmVmcwoKVGhlIHJlZnMgZmllbGQgaW4gc3RydWN0IGlvX3JzcmNfbm9kZSBp
cyBhIHBsYWluIGludCBwcm90ZWN0ZWQgYnkKY3R4LT51cmluZ19sb2NrLiBXaGlsZSB0aGUgY3Vy
cmVudCBsb2NraW5nIGlzIGNvcnJlY3QgYW5kIHByZXZlbnRzCmNvbmN1cnJlbnQgYWNjZXNzLCB1
c2luZyBhIHBsYWluIGludCBtZWFucyB0aGUga2VybmVsJ3MgcmVmY291bnQKb3ZlcmZsb3cvdW5k
ZXJmbG93IGRldGVjdGlvbiAoUkVGQ09VTlRfRlVMTCBvciBSRUZDT1VOVF9BUkNIX09QVElNSVpF
RCkKaXMgYnlwYXNzZWQuCgpJZiBhIGZ1dHVyZSBjaGFuZ2UgYWNjaWRlbnRhbGx5IHJlbW92ZXMg
dGhlIGxvY2sgb3IgaW50cm9kdWNlcyBhIG5ldwpwYXRoIHRoYXQgYnVtcHMgcmVmcyB3aXRob3V0
IGhvbGRpbmcgdXJpbmdfbG9jaywgYSBwbGFpbiBpbnQgd291bGQKc2lsZW50bHkgd3JhcC4gcmVm
Y291bnRfdCB3b3VsZCBjYXRjaCB0aGlzIHZpYSBXQVJOX09OQ0UgYW5kIHNhdHVyYXRlCmF0IDAg
b3IgSU5UX01BWCwgcHJldmVudGluZyB1c2UtYWZ0ZXItZnJlZSBpbiB0aGUgbm9kZS4KCmlvX21h
cHBlZF91YnVmIGluIHRoZSBzYW1lIGhlYWRlciBhbHJlYWR5IHVzZXMgcmVmY291bnRfdCBmb3Ig
aXRzIHJlZnMKZmllbGQ7IGFsaWduIGlvX3JzcmNfbm9kZSB3aXRoIHRoZSBzYW1lIGNvbnZlbnRp
b24uCgpObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4KClNpZ25lZC1vZmYtYnk6IE9sZWcg
U2V2b3N0eWFub3YgCi0tLQogaW9fdXJpbmcvcnNyYy5jIHwgIDggKysrKy0tLS0KIGlvX3VyaW5n
L3JzcmMuaCB8ICA0ICsrKy0KIDIgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA1IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2lvX3VyaW5nL3JzcmMuYyBiL2lvX3VyaW5nL3JzcmMu
YwppbmRleCB4eHh4eHh4Li54eHh4eHh4IDEwMDY0NAotLS0gYS9pb191cmluZy9yc3JjLmMKKysr
IGIvaW9fdXJpbmcvcnNyYy5jCkBAIC0xNDQsNyArMTQ0LDcgQEAgc3RydWN0IGlvX3JzcmNfbm9k
ZSAqaW9fcnNyY19ub2RlX2FsbG9jKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4LCBpbnQgdHlwZSkK
IAlub2RlID0gaW9fY2FjaGVfYWxsb2MoJmN0eC0+bm9kZV9jYWNoZSwgR0ZQX0tFUk5FTCk7CiAJ
aWYgKG5vZGUpIHsKIAkJbm9kZS0+dHlwZSA9IHR5cGU7Ci0JCW5vZGUtPnJlZnMgPSAxOworCQly
ZWZjb3VudF9zZXQoJm5vZGUtPnJlZnMsIDEpOwogCQlub2RlLT50YWcgPSAwOwogCQlub2RlLT5m
aWxlX3B0ciA9IDA7CiAJfQpAQCAtMTExNCw3ICsxMTE0LDcgQEAgc3RydWN0IGlvX3JzcmNfbm9k
ZSAqaW9fYnVmX25vZGVfbG9va3VwKHN0cnVjdCBpb191cmluZ19idWZfbm9kZV9yZXEgKnJlcSwK
IAlpb19yaW5nX3N1Ym1pdF9sb2NrKGN0eCwgaXNzdWVfZmxhZ3MpOwogCW5vZGUgPSBpb19yc3Jj
X25vZGVfbG9va3VwKCZjdHgtPmJ1Zl90YWJsZSwgcmVxLT5idWZfaW5kZXgpOwogCWlmIChub2Rl
KSB7Ci0JCW5vZGUtPnJlZnMrKzsKKwkJcmVmY291bnRfaW5jKCZub2RlLT5yZWZzKTsKIAkJcmVx
LT5idWZfbm9kZSA9IG5vZGU7CiAJCWlvX3Jpbmdfc3VibWl0X3VubG9jayhjdHgsIGlzc3VlX2Zs
YWdzKTsKIAkJcmV0dXJuIG5vZGU7CkBAIC0xMTk2LDcgKzExOTYsNyBAQCBpbnQgaW9fY2xvbmVf
YnVmZmVycyhzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgc3RydWN0IGlvX3JpbmdfY3R4ICpzcmNf
Y3R4LAogCWZvciAoaSA9IDA7IGkgPCBtaW4oYXJnLT5kc3Rfb2ZmLCBjdHgtPmJ1Zl90YWJsZS5u
cik7IGkrKykgewogCQlzdHJ1Y3QgaW9fcnNyY19ub2RlICpub2RlID0gY3R4LT5idWZfdGFibGUu
bm9kZXNbaV07CgogCQlpZiAobm9kZSkgewogCQkJZGF0YS5ub2Rlc1tpXSA9IG5vZGU7Ci0JCQlu
b2RlLT5yZWZzKys7CisJCQlyZWZjb3VudF9pbmMoJm5vZGUtPnJlZnMpOwogCQl9CiAJfQpAQCAt
MTIyOSw3ICsxMjI5LDcgQEAgaW50IGlvX2Nsb25lX2J1ZmZlcnMoc3RydWN0IGlvX3JpbmdfY3R4
ICpjdHgsIHN0cnVjdCBpb19yaW5nX2N0eCAqc3JjX2N0eCwKIAlmb3IgKGkgPSBuYnVmczsgaSA8
IGN0eC0+YnVmX3RhYmxlLm5yOyBpKyspIHsKIAkJc3RydWN0IGlvX3JzcmNfbm9kZSAqbm9kZSA9
IGN0eC0+YnVmX3RhYmxlLm5vZGVzW2ldOwoKIAkJaWYgKG5vZGUpIHsKIAkJCWRhdGEubm9kZXNb
aV0gPSBub2RlOwotCQkJbm9kZS0+cmVmcysrOworCQkJcmVmY291bnRfaW5jKCZub2RlLT5yZWZz
KTsKIAkJfQogCX0KCmRpZmYgLS1naXQgYS9pb191cmluZy9yc3JjLmggYi9pb191cmluZy9yc3Jj
LmgKaW5kZXggeHh4eHh4eC4ueHh4eHh4eCAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvcnNyYy5oCisr
KyBiL2lvX3VyaW5nL3JzcmMuaApAQCAtMiw2ICsyLDggQEAKICNpZm5kZWYgSU9VX1JTUkNfSAog
I2RlZmluZSBJT1VfUlNSQ19ICgorI2luY2x1ZGUgPGxpbnV4L3JlZmNvdW50Lmg+CisKICNpbmNs
dWRlIDxsaW51eC9pb191cmluZ190eXBlcy5oPgogI2luY2x1ZGUgPGxpbnV4L2xvY2tkZXAuaD4K
CkBAIC0xNCw3ICsxNiw3IEBAIGVudW0gewogc3RydWN0IGlvX3JzcmNfbm9kZSB7CiAJdW5zaWdu
ZWQgY2hhcgkJCXR5cGU7Ci0JaW50CQkJCXJlZnM7CisJcmVmY291bnRfdAkJCXJlZnM7CgogCXU2
NCB0YWc7CiAJdW5pb24gewpAQCAtMTA0LDcgKzEwNiw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBp
b19wdXRfcnNyY19ub2RlKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4LAogCQkJCSAgICBzdHJ1Y3Qg
aW9fcnNyY19ub2RlICpub2RlKQogewogCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJmN0eC0+dXJpbmdf
bG9jayk7Ci0JaWYgKCEtLW5vZGUtPnJlZnMpCisJaWYgKHJlZmNvdW50X2RlY19hbmRfdGVzdCgm
bm9kZS0+cmVmcykpCiAJCWlvX2ZyZWVfcnNyY19ub2RlKGN0eCwgbm9kZSk7CiB9Ci0tCjIuNDQu
MAo=
--000000000000ee87a00651bb2600--

