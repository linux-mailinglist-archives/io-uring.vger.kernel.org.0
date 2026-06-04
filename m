Return-Path: <io-uring+bounces-13609-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id FFedNuLKIWrPNgEAu9opvQ
	(envelope-from <io-uring+bounces-13609-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 04 Jun 2026 20:58:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DA9E4642C32
	for <lists+io-uring@lfdr.de>; Thu, 04 Jun 2026 20:58:41 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=janestreet.com header.s=google header.b=L5epZKPy;
	dkim=pass header.d=janestreet.com header.s=waixah header.b=2fBWv8gF;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13609-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13609-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=janestreet.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C2B423009E0C
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2026 18:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6391137EFE2;
	Thu,  4 Jun 2026 18:52:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mxout1.mail.janestreet.com (mxout1.mail.janestreet.com [38.105.200.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40BC260565
	for <io-uring@vger.kernel.org>; Thu,  4 Jun 2026 18:52:31 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780599153; cv=fail; b=lUC5iuoVunQSzOWRT2IMLrHgIYrpkcgo2kT7cHIO3DCY6fU6xdVYeesVvQ2yOmFQHHPuc9MPydTRo1X2QqLY8Lm4cV/dSBR0MPz+yjLjjaSJq269cfrnZiiFNBl3P+lwdYYwraNQw5eN4GO1YVzPaFhORgAdPziu2wiquP6wYcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780599153; c=relaxed/simple;
	bh=8heG/pRYsdnPv2dWN2tSZbVHLmOj332tTquy6KRDXhE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=E7yLNKh7z4pxYhDOc/Zwfx6KTZP75Bie8/CLuENPPGpPgkfBJWB11mTeVMOG7/LKpYr0DB4Nfk44El9B1H05dU6sLHQtnJR0yAOueQxiPP/u5ouXLquzVoJnENemVJGx9f9lA1TYeQYwgMGy8kwdkdLociPMpIGp3kXfKaCPyrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com; spf=pass smtp.mailfrom=janestreet.com; dkim=pass (1024-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=L5epZKPy; dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=2fBWv8gF; arc=fail smtp.client-ip=38.105.200.78
Received: from mail-lf1-f69.google.com ([209.85.167.69])
 	by mxgoog2.mail.janestreet.com with esmtps (TLS1.3:TLS_AES_128_GCM_SHA256:128)
 	(Exim 4.99.4)
 	id 1wVD61-00000000R2I-2Whj
 	for io-uring@vger.kernel.org;
 	Thu, 04 Jun 2026 14:47:13 -0400
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5aa63daf1a6so712603e87.0
         for <io-uring@vger.kernel.org>; Thu, 04 Jun 2026 11:47:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780598832; cv=none;
         d=google.com; s=arc-20240605;
         b=kiK793Kc6KH/58Q6oGRWHiVqhRBmZnttzSQHSQ5iVLEsBTpC2AuM19WaPyhP9Qb+ld
          7wvlS2im3b1RTOa35rgp4wLkt5A0K1W6AWfaSgKVLStMwNlfh8Z2vZF+TGnbjPPNczhe
          0hJIADNrIClcSMQoKlRIbB/xXRLz4z9krGUBKfnvCgvSsriJu5IIikr3SuCaiE5BiL9M
          On28j3Iq3lHa3w/SirZg3nuZA2CpfPFSexL6cU3UJsAsJtbANrQkneNIITQIpIyDSac7
          bFxVmfwJjym9xvFynox2g8FtUGO1eCFrsD1gtqQHm12115aXEdx021LCLAKmCE2u1leM
          A/pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
         h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
         bh=lQCuVGxP/BV7D5/gaSpLO06j/STwXOEP1EwPpL+2jB0=;
         fh=IUA93xdJhdfAodZgGBs/NFjSrP5cWMsL5AAiL5SWYtM=;
         b=TnK5+qr2OrxlRtvvRhbFOniTnD0zC72/7qnas2o7owY2+687nC7yVZRNI66v/zJuJH
          nMrdq5zvKhEvjv03WtWbyQg1IEyjj6rh+wTaUANpbPqh2+NLF1r7vr2bHyDhNH1xlUhM
          v+f5CpspWhnEz/n0jVNCfIL++mvjR8vzmA0tTUdUzf5E7XN/LFk02sbHdSQz/cwtaAuZ
          OgGrr7wilH9nuuBIWtuAOyeKF+ncYolGwF9wTS+Lo6BxZu7npPOVrrUhrSOia4ifGwGx
          UWMXeMyTMRM3zvyZaHDHWcxZZqGHqCdLcAYtUmRSN+01W6ovEbEcV96l9Eexf0jckptc
          2D2g==;
         darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=janestreet.com; s=google; t=1780598832; x=1781203632; darn=vger.kernel.org;
         h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
          :date:message-id:reply-to;
         bh=lQCuVGxP/BV7D5/gaSpLO06j/STwXOEP1EwPpL+2jB0=;
         b=L5epZKPyjAyYw9xn6/9PHSY+dShZcNZXBossYKByyvc/tVqKbDA4WI1CticlyWW7N3
          W1m+T4cHYSS0l77xYEbJSqugkkLsG5JvyPeIoOnjwey6qVyZdacuKXkqGYCj4IhUm7na
          P6gOsEVvH+3plqfM9qEl7BYVF9vEAV8aYDpLI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1780598833;
  bh=lQCuVGxP/BV7D5/gaSpLO06j/STwXOEP1EwPpL+2jB0=;
  h=From:Date:Subject:To:Cc;
  b=2fBWv8gFFz4PsLZWziE17Y+D5qFv14ktW6YXx6gJyN9gfpv/n4PHPfVajdS1oRWKw
  q9kStJqXAItN/CP/v03uSDS4o8OylP90w2pbPkBfVbcn9SgAJX8I47TZzuN5xC21eo
  JHCT1nRFdCVPz27qPhdQOI7XqzleXFRFVKyuVimcysWmCNlRoQWpIRsrNtKLW+ey37
  aix2+ZZ0Oix0hhIFKhrCX8i8OFYW3+uU2d2I2Bgdy3y9nyK//pRpkTWeutId059MFm
  0lRTfbbm44i00GpOy2PmwLDzzYOuw/Y0TYD6HM0IhZ9n42P0oPoLkt26mT0GKI+juD
  kgmH7m3TfpKnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=1e100.net; s=20251104; t=1780598832; x=1781203632;
         h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
          :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
         bh=lQCuVGxP/BV7D5/gaSpLO06j/STwXOEP1EwPpL+2jB0=;
         b=CnxWa9NZd18tBs7CCd+lqbL3wu8m6ZWVdJhIdnKBZ+fk11xJzJfjmmjGrU3tFeHxWs
          emcX8Qn/YjDcmQMXj39rkZUD4FvwsBG4Yi34Xcx5hoXSam0kcY1YhPEw63D/EiDnFBaB
          4CSBFgRydLMBPrS7+eXAImDsuUdiZeXj5+N4LjKeZyGSGKUT+4XAPkd+MmC7HIshxOYw
          6M6mPAW3N1iB9tSZuxJOkq0rbbu3qerddtqfLUn5vojzn4jrQQ+/wi/CMXR1Pj6SCL8x
          SrxuafiFFz8TXn3rNfVQEVZMEf4fQR49aA24MgL+sjuB1C44b4MVcjU8qLWNk3h12BNg
          Hsxw==
X-Forwarded-Encrypted: i=1; AFNElJ/Ap1R4qGEvG+QHxV1BNOi1QOyYffOymq1hoVF+ez35VYWWGLSEhFDYCs2LywIRiAzY6vJ1UDcv+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxxR9eA9St+E27oyqP6KU6mpkHhxdWNKl0TzneVvySDwSTGmXlp
 	fAedqXyxvJmZlYU73PkE4Vaifo6onzrdfbuh8X1EpmEfjdCmBMcI05i5YjMY8LHkPTNT89Tmmpf
 	+vVAVlh2NkXCmqq5cxE/wsJVgRTRWgwNSq7FEYgoDmcHRpq5PTRCEP1+2enyyyW7TkKzxnWn38v
 	T1ZoVgxgPRS6AAs5f8k6h5ISp0S0WrQGZ7vg==
X-Gm-Gg: Acq92OH7gZsvxl/YbRjDk/CCJyxmbo6gsirA5A2YML8vT/9zu5dyVbwCJdgB07vYp/Q
 	smK/GR0k8l+fhl6MbKEl2/bLaMOpcCme/ivNymt6TTEzVnQOv7OlmI4hseyPxkrrwVN0+J+F2/O
 	fMoJ8WPn7MD5fp6Lgj+VocZcrQF6+Pcj9hlNStb3b5BaYsh1l6SoHBi/y3pt5Vhzck0FcIR1O86
 	vXUoF5kGW1ULm1/
X-Received: by 2002:a05:6512:124c:b0:5aa:6df7:4ea9 with SMTP id 2adb3069b0e04-5aa87bcacc8mr10566e87.35.1780598832332;
         Thu, 04 Jun 2026 11:47:12 -0700 (PDT)
X-Received: by 2002:a05:6512:124c:b0:5aa:6df7:4ea9 with SMTP id
  2adb3069b0e04-5aa87bcacc8mr10551e87.35.1780598831837; Thu, 04 Jun 2026
  11:47:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Gregg Leventhal <gleventhal@janestreet.com>
Date: Thu, 4 Jun 2026 14:46:33 -0400
X-Gm-Features: AVHnY4JX0Q2JrT_P8ExKcbOaAxWCVdhJ719iXGaFfyvnGit06GPdlxX2aHAE0J4
Message-ID: <CAFN_u7FrgM4Dzie2jjkLwWV8P0dvUG_Wwy3Q9B3-2HnnWiDu8w@mail.gmail.com>
Subject: [BUG] iomap/io_uring: O_APPEND async buffered write silently
  re-appends a data chunk (corruption) on XFS, 6.1.y/6.12.y
To: hch@infradead.org, djwong@kernel.org, bfoster@redhat.com, 
 	Eric Hagberg <ehagberg@janestreet.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000dc1e61065371f8a6"
X-Rspamd-Action: no action
X-Spamd-Result: default: False [2.54 / 15.00];
	MIME_BAD_ATTACHMENT(1.60)[c:text/x-csrc];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[janestreet.com,quarantine];
	R_DKIM_ALLOW(-0.20)[janestreet.com:s=google,janestreet.com:s=waixah];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[multipart/mixed,multipart/alternative,text/plain,text/x-csrc];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13609-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[gleventhal@janestreet.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:~,4:+];
	FORGED_RECIPIENTS(0.00)[m:hch@infradead.org,m:djwong@kernel.org,m:bfoster@redhat.com,m:ehagberg@janestreet.com,m:linux-xfs@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:stable@vger.kernel.org,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[janestreet.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gleventhal@janestreet.com,io-uring@vger.kernel.org];
	HAS_ATTACHMENT(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,janestreet.com:dkim,janestreet.com:from_mime,janestreet.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DA9E4642C32

--000000000000dc1e61065371f8a6
Content-Type: multipart/alternative; boundary="000000000000dc1e5f065371f8a4"

--000000000000dc1e5f065371f8a4
Content-Type: text/plain; charset="UTF-8"

Hi all,

We're seeing silent data corruption -- a chunk of a buffered write being
silently repeated at a later offset -- when using io_uring async buffered
writes with O_APPEND on XFS. It reproduces on the longterm stable trees
6.1.y and 6.12.y under memory pressure, and is fixed in 6.18.y.

Summary
-------
On XFS, an io_uring async buffered write to a file opened O_APPEND can
silently write a chunk of data twice. This is not a harmless in-place
rewrite: a page-aligned, page-multiple sub-range is re-appended at a later
offset, so the file grows and ends up containing the same run of bytes
twice in sequence (and everything after the duplicate is shifted relative
to what was intended). The CQE reports the full requested byte count
(userspace sees success), the resulting file is larger than the total
bytes the kernel reported writing, and there is no error and no dmesg
warning.

Affected kernels (vanilla stable trees; we run ELRepo builds of userspace)
  - 6.1.173   (observed as 6.1.173-1.el8.x86_64)
  - 6.12.85   (observed as 6.12.85-1.el8.x86_64)
Filesystem: XFS

Unaffected:
  - 6.18.y

Trigger conditions
------------------
  - O_APPEND specific. With an explicit file offset (no O_APPEND) we do
    not observe the corruption.
  - Only manifests under memory pressure. The reproducer triggers
    reliably when the system is under enough memory/paging pressure and
    does not reproduce on an otherwise idle box.

Root cause (our understanding)
------------------------------
Under memory pressure the inline IOCB_NOWAIT attempt commits a partial,
non-page-aligned amount and returns short at a page boundary. The pre-fix
iomap_write_iter() reverts the iov_iter by the bytes already written and
returns -EAGAIN:

    } while (iov_iter_count(i) && length);

    if (status == -EAGAIN) {
        iov_iter_revert(i, total_written);
        return -EAGAIN;
    }
    return total_written ? total_written : status;

io_uring then reissues the page-aligned remainder on io-wq. Because the
write is O_APPEND, the offset is re-resolved to the current EOF, which now
already includes the bytes committed by the inline attempt. The result is
that a page-aligned sub-range is written a second time, re-appended past
the new EOF rather than landing where it was originally intended.

What fixes it
-------------
We did not bisect. We identified Brian Foster's "iomap: incremental
per-operation iter advance" series as the likely relevant change,
backported it to the affected kernel, and confirmed it makes the
reproducer pass. The series was merged for v6.15:


https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.18.y&id=30f530096166202cf70e1b7d1de5a8cdfba42af1

It reworks iomap_write_iter() to advance iter->pos/iter->len incrementally
(iomap_iter_advance) and removes the iov_iter_revert/-EAGAIN handling, so
retries resume from the correct offset. The buffered-write change is in
"iomap: advance the iter directly on buffered writes" (d9dc477ff6a2), but
it depends on the earlier infrastructure patches in the same series.

Detection in the reproducer (both silent)
-----------------------------------------
  1) final file size > sum of CQE byte counts the kernel reported.
  2) the file is filled with a u64 "byte offset / 8" pattern, so on
     readback element j must equal j; the first mismatch marks the start
     of the duplicated copy (observed to be page-aligned).

Reproducer
----------
Build: gcc -O2 -o repro_uring_dup repro_uring_dup.c -luring
Run:   ./repro_uring_dup /path/on/xfs/repro [seconds] [file_target_mb]
Needs the system under memory pressure to trigger; under those conditions
it reproduces reliably. Source attached (repro_uring_dup.c).

Notes on stable
---------------
The fix is a refactor with no Fixes: tag, and the buffered-write commit
builds on the preceding patches in the series, so a single-commit
cherry-pick into 6.1.y / 6.12.y doesn't look feasible. We're wondering
whether a smaller, targeted fix would be more backportable for the active
LTS trees -- e.g. ensuring the -EAGAIN retry path keeps the append
position consistent with the reverted iov_iter so the already-committed
range isn't re-appended -- but we'd defer to your judgment on whether that
is sound or whether backporting the series as a unit is the better path.
Given this is silent data corruption present since io_uring async buffered
write support (~v6.0), we'd appreciate guidance on the right approach.

Happy to test patches and provide any additional detail.

Regards,
Gregg Leventhal <gleventhal@janestreet.com> and Eric Hagberg <
ehagberg@janestreet.com>

--000000000000dc1e5f065371f8a4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi all,<br><br>We&#39;re seeing silent data corruption -- =
a chunk of a buffered write being<br>silently repeated at a later offset --=
 when using io_uring async buffered<br>writes with O_APPEND on XFS. It repr=
oduces on the longterm stable trees<br>6.1.y and 6.12.y under memory pressu=
re, and is fixed in 6.18.y.<br><br>Summary<br>-------<br>On XFS, an io_urin=
g async buffered write to a file opened O_APPEND can<br>silently write a ch=
unk of data twice. This is not a harmless in-place<br>rewrite: a page-align=
ed, page-multiple sub-range is re-appended at a later<br>offset, so the fil=
e grows and ends up containing the same run of bytes<br>twice in sequence (=
and everything after the duplicate is shifted relative<br>to what was inten=
ded). The CQE reports the full requested byte count<br>(userspace sees succ=
ess), the resulting file is larger than the total<br>bytes the kernel repor=
ted writing, and there is no error and no dmesg<br>warning.<br><br>Affected=
 kernels (vanilla stable trees; we run ELRepo builds of userspace)<br>=C2=
=A0 - 6.1.173 =C2=A0 (observed as 6.1.173-1.el8.x86_64)<br>=C2=A0 - 6.12.85=
 =C2=A0 (observed as 6.12.85-1.el8.x86_64)<br>Filesystem: XFS<br><br>Unaffe=
cted:<br>=C2=A0 - 6.18.y<br><br>Trigger conditions<br>------------------<br=
>=C2=A0 - O_APPEND specific. With an explicit file offset (no O_APPEND) we =
do<br>=C2=A0 =C2=A0 not observe the corruption.<br>=C2=A0 - Only manifests =
under memory pressure. The reproducer triggers<br>=C2=A0 =C2=A0 reliably wh=
en the system is under enough memory/paging pressure and<br>=C2=A0 =C2=A0 d=
oes not reproduce on an otherwise idle box.<br><br>Root cause (our understa=
nding)<br>------------------------------<br>Under memory pressure the inlin=
e IOCB_NOWAIT attempt commits a partial,<br>non-page-aligned amount and ret=
urns short at a page boundary. The pre-fix<br>iomap_write_iter() reverts th=
e iov_iter by the bytes already written and<br>returns -EAGAIN:<br><br>=C2=
=A0 =C2=A0 } while (iov_iter_count(i) &amp;&amp; length);<br><br>=C2=A0 =C2=
=A0 if (status =3D=3D -EAGAIN) {<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 iov_iter_re=
vert(i, total_written);<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EAGAIN;<br>=
=C2=A0 =C2=A0 }<br>=C2=A0 =C2=A0 return total_written ? total_written : sta=
tus;<br><br>io_uring then reissues the page-aligned remainder on io-wq. Bec=
ause the<br>write is O_APPEND, the offset is re-resolved to the current EOF=
, which now<br>already includes the bytes committed by the inline attempt. =
The result is<br>that a page-aligned sub-range is written a second time, re=
-appended past<br>the new EOF rather than landing where it was originally i=
ntended.<br><br>What fixes it<br>-------------<br>We did not bisect. We ide=
ntified Brian Foster&#39;s &quot;iomap: incremental<br>per-operation iter a=
dvance&quot; series as the likely relevant change,<br>backported it to the =
affected kernel, and confirmed it makes the<br>reproducer pass. The series =
was merged for v6.15:<br><br>=C2=A0 <a href=3D"https://git.kernel.org/pub/s=
cm/linux/kernel/git/stable/linux.git/commit/?h=3Dlinux-6.18.y&amp;id=3D30f5=
30096166202cf70e1b7d1de5a8cdfba42af1">https://git.kernel.org/pub/scm/linux/=
kernel/git/stable/linux.git/commit/?h=3Dlinux-6.18.y&amp;id=3D30f5300961662=
02cf70e1b7d1de5a8cdfba42af1</a><br><br>It reworks iomap_write_iter() to adv=
ance iter-&gt;pos/iter-&gt;len incrementally<br>(iomap_iter_advance) and re=
moves the iov_iter_revert/-EAGAIN handling, so<br>retries resume from the c=
orrect offset. The buffered-write change is in<br>&quot;iomap: advance the =
iter directly on buffered writes&quot; (d9dc477ff6a2), but<br>it depends on=
 the earlier infrastructure patches in the same series.<br><br>Detection in=
 the reproducer (both silent)<br>-----------------------------------------<=
br>=C2=A0 1) final file size &gt; sum of CQE byte counts the kernel reporte=
d.<br>=C2=A0 2) the file is filled with a u64 &quot;byte offset / 8&quot; p=
attern, so on<br>=C2=A0 =C2=A0 =C2=A0readback element j must equal j; the f=
irst mismatch marks the start<br>=C2=A0 =C2=A0 =C2=A0of the duplicated copy=
 (observed to be page-aligned).<br><br>Reproducer<br>----------<br>Build: g=
cc -O2 -o repro_uring_dup repro_uring_dup.c -luring<br>Run: =C2=A0 ./repro_=
uring_dup /path/on/xfs/repro [seconds] [file_target_mb]<br>Needs the system=
 under memory pressure to trigger; under those conditions<br>it reproduces =
reliably. Source attached (repro_uring_dup.c).<br><br>Notes on stable<br>--=
-------------<br>The fix is a refactor with no Fixes: tag, and the buffered=
-write commit<br>builds on the preceding patches in the series, so a single=
-commit<br>cherry-pick into 6.1.y / 6.12.y doesn&#39;t look feasible. We&#3=
9;re wondering<br>whether a smaller, targeted fix would be more backportabl=
e for the active<br>LTS trees -- e.g. ensuring the -EAGAIN retry path keeps=
 the append<br>position consistent with the reverted iov_iter so the alread=
y-committed<br>range isn&#39;t re-appended -- but we&#39;d defer to your ju=
dgment on whether that<br>is sound or whether backporting the series as a u=
nit is the better path.<br>Given this is silent data corruption present sin=
ce io_uring async buffered<br>write support (~v6.0), we&#39;d appreciate gu=
idance on the right approach.<br><br>Happy to test patches and provide any =
additional detail.<br><br>Regards,<br>Gregg Leventhal &lt;<a href=3D"mailto=
:gleventhal@janestreet.com">gleventhal@janestreet.com</a>&gt; and Eric Hagb=
erg &lt;<a href=3D"mailto:ehagberg@janestreet.com">ehagberg@janestreet.com<=
/a>&gt;<br></div>

--000000000000dc1e5f065371f8a4--
--000000000000dc1e61065371f8a6
Content-Type: text/x-csrc; charset="US-ASCII"; name="repro_uring_dup.c"
Content-Disposition: attachment; filename="repro_uring_dup.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mpzr6ziv0>
X-Attachment-Id: f_mpzr6ziv0

LyoKICogcmVwcm9fdXJpbmdfZHVwLmMKICoKICogUmVwcm9kdWNlciBmb3IgaW9fdXJpbmcgYXN5
bmMgYnVmZmVyZWQtd3JpdGUgZHVwbGljYXRpb24gb24gWEZTLgogKiBJc3N1ZXMgbGFyZ2UsIHZh
cmlhYmxlLXNpemUsIG5vbi1wYWdlLWFsaWduZWQgYnVmZmVyZWQgd3JpdGV2J3MgYXBwZW5kZWQK
ICogdG8gYSBmaWxlIHZpYSBpb191cmluZyB3aXRoIG9mZnNldCAtMSAoInVzZSBjdXJyZW50IHBv
c2l0aW9uIikuCiAqCiAqIEJ1Zzogd2hlbiB0aGUgaW5saW5lIElPQ0JfTk9XQUlUIGF0dGVtcHQg
ZG9lcyBhIHBhcnRpYWwtcGFnZSBzaG9ydCB3cml0ZQogKiAobGFuZGluZyBvbiBhIHBhZ2UgYm91
bmRhcnkpIGFuZCB0aGUgcGFnZS1hbGlnbmVkIHJlbWFpbmRlciBpcyByZWlzc3VlZCBvbgogKiBp
by13cSwgYSBwYWdlLWFsaWduZWQsIHBhZ2UtbXVsdGlwbGUgc3ViLXJhbmdlIG9mIHRoZSByZW1h
aW5kZXIgaXMgd3JpdHRlbgogKiBUV0lDRSwgd2hpbGUgdGhlIENRRSBzdGlsbCByZXBvcnRzIHRo
ZSBmdWxsIHJlcXVlc3RlZCBieXRlIGNvdW50LiBSZXN1bHQ6CiAqIHRoZSBmaWxlIGlzIGxhcmdl
ciB0aGFuIHRoZSBieXRlcyB3ZSB3ZXJlIHRvbGQgc3VjY2VlZGVkLCB3aXRoIGEgcGFnZS1hbGln
bmVkCiAqIGR1cGxpY2F0ZWQgY2h1bmsuCiAqCiAqIERldGVjdGlvbiAoYm90aCBzaWxlbnQgLSBu
byBlcnJvciBpcyBldmVyIHJldHVybmVkKToKICogICAxKSBmaW5hbCBmaWxlIHNpemUgPiB0b3Rh
bCBieXRlcyB0aGUga2VybmVsIHRvbGQgdXMgaXQgd3JvdGUuCiAqICAgMikgZmlsZSBpcyBmaWxs
ZWQgd2l0aCBhIHU2NCAiYnl0ZSBvZmZzZXQgLyA4IiBwYXR0ZXJuLCBzbyBvbiByZWFkYmFjawog
KiAgICAgIGVsZW1lbnQgaiBtdXN0IGVxdWFsIGo7IHRoZSBmaXJzdCBqIHdoZXJlIGl0IGRvZXNu
J3QgaXMgdGhlIHN0YXJ0IG9mIHRoZQogKiAgICAgIGR1cGxpY2F0ZWQgY29weSAoZXhwZWN0ZWQg
dG8gYmUgcGFnZS1hbGlnbmVkKS4KICoKICogQnVpbGQ6ICBnY2MgLU8yIC1vIHJlcHJvX3VyaW5n
X2R1cCByZXByb191cmluZ19kdXAuYyAtbHVyaW5nCiAqIFJ1bjogICAgLi9yZXByb191cmluZ19k
dXAgL3BhdGgvb24veGZzL3JlcHJvIFtzZWNvbmRzXSBbZmlsZV90YXJnZXRfbWJdCiAqLwojZGVm
aW5lIF9HTlVfU09VUkNFCiNpbmNsdWRlIDxsaWJ1cmluZy5oPgojaW5jbHVkZSA8ZmNudGwuaD4K
I2luY2x1ZGUgPHN0ZGludC5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5o
PgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDx0aW1lLmg+CiNpbmNsdWRlIDx1bmlzdGQu
aD4KI2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxzeXMvc3RhdC5oPgojaW5jbHVkZSA8c3lz
L3Vpby5oPgoKI2RlZmluZSBRRCA4CiNkZWZpbmUgTUIgKDEwMjRVTCAqIDEwMjRVTCkKI2RlZmlu
ZSBNQVhDSFVOSyAoMjRVTCAqIE1CKQojZGVmaW5lIE1JTkNIVU5LICgxVUwgKiBNQikKCi8qIDE6
IE9fQVBQRU5EIC8gb2Zmc2V0IC0xIHZhcmlhbnQgKGNvcnJ1cHRzKS4KICogMDogbm8gT19BUFBF
TkQsIGV4cGxpY2l0IG9mZnNldCB2YXJpYW50IChkb2VzIG5vdCBjb3JydXB0KS4gKi8Kc3RhdGlj
IGludCB1c2VfYXBwZW5kID0gMTsKCnN0YXRpYyB1aW50NjRfdCBub3dfbnModm9pZCkgewogIHN0
cnVjdCB0aW1lc3BlYyB0czsKICBjbG9ja19nZXR0aW1lKENMT0NLX01PTk9UT05JQywgJnRzKTsK
ICByZXR1cm4gKHVpbnQ2NF90KXRzLnR2X3NlYyAqIDEwMDAwMDAwMDBVTEwgKyAodWludDY0X3Qp
dHMudHZfbnNlYzsKfQoKLyogRmlsbCBidWYgc28gdGhlIHU2NCBhdCBnbG9iYWwgYnl0ZSBvZmZz
ZXQgKGJhc2UrOCppKSBob2xkcyAoYmFzZSs4KmkpLzguICovCnN0YXRpYyB2b2lkIGZpbGxfcGF0
dGVybih1aW50NjRfdCAqYnVmLCB1aW50NjRfdCBiYXNlX2J5dGVzLCBzaXplX3QgbGVuKSB7CiAg
dWludDY0X3Qgc3RhcnRfaWR4ID0gYmFzZV9ieXRlcyAvIDg7CiAgc2l6ZV90IG4gPSBsZW4gLyA4
OwogIGZvciAoc2l6ZV90IGkgPSAwOyBpIDwgbjsgaSsrKQogICAgYnVmW2ldID0gc3RhcnRfaWR4
ICsgaTsKfQoKLyogT25lIHdyaXRldjsgbG9vcHMgb3ZlciAobGVnaXRpbWF0ZWx5KSBzaG9ydCAq
cmV0dXJuZWQqIHJlc3VsdHMuICovCnN0YXRpYyB2b2lkIHdyaXRlX2FsbChzdHJ1Y3QgaW9fdXJp
bmcgKnJpbmcsIGludCBmZCwgdWludDhfdCAqYnVmLCBzaXplX3QgbGVuLAogICAgICAgICAgICAg
ICAgICAgICAgdWludDY0X3QgZXhwZWN0ZWQpIHsKICBzaXplX3QgZG9uZSA9IDA7CiAgd2hpbGUg
KGRvbmUgPCBsZW4pIHsKICAgIHN0cnVjdCBpb191cmluZ19zcWUgKnNxZSA9IGlvX3VyaW5nX2dl
dF9zcWUocmluZyk7CiAgICBzdHJ1Y3QgaW92ZWMgaW92ID0gey5pb3ZfYmFzZSA9IGJ1ZiArIGRv
bmUsIC5pb3ZfbGVuID0gbGVuIC0gZG9uZX07CiAgICBsb25nIGxvbmcgb2ZmID0gdXNlX2FwcGVu
ZCA/IC0xTEwgOiAobG9uZyBsb25nKShleHBlY3RlZCArIGRvbmUpOwogICAgaW9fdXJpbmdfcHJl
cF93cml0ZXYoc3FlLCBmZCwgJmlvdiwgMSwgKHVuc2lnbmVkIGxvbmcgbG9uZylvZmYpOwoKICAg
IGludCByZXQgPSBpb191cmluZ19zdWJtaXQocmluZyk7CiAgICBpZiAocmV0IDwgMCkgewogICAg
ICBmcHJpbnRmKHN0ZGVyciwgInN1Ym1pdDogJXNcbiIsIHN0cmVycm9yKC1yZXQpKTsKICAgICAg
ZXhpdCgxKTsKICAgIH0KCiAgICBzdHJ1Y3QgaW9fdXJpbmdfY3FlICpjcWU7CiAgICByZXQgPSBp
b191cmluZ193YWl0X2NxZShyaW5nLCAmY3FlKTsKICAgIGlmIChyZXQgPCAwKSB7CiAgICAgIGZw
cmludGYoc3RkZXJyLCAid2FpdF9jcWU6ICVzXG4iLCBzdHJlcnJvcigtcmV0KSk7CiAgICAgIGV4
aXQoMSk7CiAgICB9CiAgICBpbnQgcmVzID0gY3FlLT5yZXM7CiAgICBpb191cmluZ19jcWVfc2Vl
bihyaW5nLCBjcWUpOwoKICAgIGlmIChyZXMgPCAwKSB7CiAgICAgIGZwcmludGYoc3RkZXJyLCAi
d3JpdGU6ICVzXG4iLCBzdHJlcnJvcigtcmVzKSk7CiAgICAgIGV4aXQoMSk7CiAgICB9CiAgICBp
ZiAocmVzID09IDApIHsKICAgICAgZnByaW50ZihzdGRlcnIsICJ3cml0ZSByZXR1cm5lZCAwXG4i
KTsKICAgICAgZXhpdCgxKTsKICAgIH0KICAgIGRvbmUgKz0gKHNpemVfdClyZXM7CiAgfQp9Cgpp
bnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpIHsKICBpZiAoYXJnYyA8IDIpIHsKICAgIGZw
cmludGYoc3RkZXJyLCAidXNhZ2U6ICVzIDxwYXRoLXByZWZpeC1vbi14ZnM+IFtzZWNvbmRzXSBb
ZmlsZV90YXJnZXRfbWJdXG4iLAogICAgICAgICAgICBhcmd2WzBdKTsKICAgIHJldHVybiAyOwog
IH0KICBjb25zdCBjaGFyICpwcmVmaXggPSBhcmd2WzFdOwogIGludCBzZWNvbmRzID0gKGFyZ2Mg
PiAyKSA/IGF0b2koYXJndlsyXSkgOiA2MDsKICB1aW50NjRfdCBmaWxlX3RhcmdldCA9ICgoYXJn
YyA+IDMpID8gKHVpbnQ2NF90KWF0b2xsKGFyZ3ZbM10pIDogNDgpICogTUI7CgogIHNyYW5kKCh1
bnNpZ25lZCkodGltZShOVUxMKSBeIGdldHBpZCgpKSk7CgogIHN0cnVjdCBpb191cmluZyByaW5n
OwogIGlmIChpb191cmluZ19xdWV1ZV9pbml0KFFELCAmcmluZywgMCkpIHsKICAgIHBlcnJvcigi
aW9fdXJpbmdfcXVldWVfaW5pdCIpOwogICAgcmV0dXJuIDE7CiAgfQoKICB1aW50OF90ICpidWYg
PSBhbGlnbmVkX2FsbG9jKDQwOTYsIE1BWENIVU5LKTsKICBpZiAoIWJ1ZikgewogICAgcGVycm9y
KCJhbGlnbmVkX2FsbG9jIik7CiAgICByZXR1cm4gMTsKICB9CgogIHN0YXRpYyB1aW50NjRfdCBy
YnVmWzEgPDwgMTZdOwogIHVpbnQ2NF90IGRlYWRsaW5lID0gbm93X25zKCkgKyAodWludDY0X3Qp
c2Vjb25kcyAqIDEwMDAwMDAwMDBVTEw7CiAgbG9uZyBmaWxlcyA9IDA7CgogIHdoaWxlIChub3df
bnMoKSA8IGRlYWRsaW5lKSB7CiAgICBjaGFyIGZuWzgxOTJdOwogICAgc25wcmludGYoZm4sIHNp
emVvZiBmbiwgIiVzLiVsZCIsIHByZWZpeCwgZmlsZXMpOwogICAgaW50IGZsYWdzID0gT19XUk9O
TFkgfCBPX0NSRUFUIHwgT19UUlVOQyB8ICh1c2VfYXBwZW5kID8gT19BUFBFTkQgOiAwKTsKICAg
IGludCBmZCA9IG9wZW4oZm4sIGZsYWdzLCAwNjQ0KTsKICAgIGlmIChmZCA8IDApIHsKICAgICAg
cGVycm9yKCJvcGVuIik7CiAgICAgIHJldHVybiAxOwogICAgfQoKICAgIHVpbnQ2NF90IGV4cGVj
dGVkID0gMDsKICAgIHdoaWxlIChleHBlY3RlZCA8IGZpbGVfdGFyZ2V0KSB7CiAgICAgIHNpemVf
dCB3YW50ID0gTUlOQ0hVTksgKyAoKHNpemVfdClyYW5kKCkgJSAoTUFYQ0hVTksgLSBNSU5DSFVO
SykpOwogICAgICB3YW50ICY9IH4oKHNpemVfdCk3KTsgLyogOC1hbGlnbjsgZGVsaWJlcmF0ZWx5
IE5PVCBwYWdlLWFsaWduZWQgKi8KICAgICAgZmlsbF9wYXR0ZXJuKCh1aW50NjRfdCAqKWJ1Ziwg
ZXhwZWN0ZWQsIHdhbnQpOwogICAgICB3cml0ZV9hbGwoJnJpbmcsIGZkLCBidWYsIHdhbnQsIGV4
cGVjdGVkKTsKICAgICAgZXhwZWN0ZWQgKz0gd2FudDsgLyogQ1FFIHJlcG9ydGVkIGZ1bGwgc3Vj
Y2VzcyAqLwogICAgfQogICAgY2xvc2UoZmQpOwoKICAgIC8qIC0tLS0gdmVyaWZ5IC0tLS0gKi8K
ICAgIHN0cnVjdCBzdGF0IHN0OwogICAgaWYgKHN0YXQoZm4sICZzdCkpIHsKICAgICAgcGVycm9y
KCJzdGF0Iik7CiAgICAgIHJldHVybiAxOwogICAgfQoKICAgIGxvbmcgbG9uZyBmaXJzdF9iYWQg
PSAtMTsKICAgIHVpbnQ2NF90IGJhZF92YWwgPSAwOwogICAgaW50IHJmZCA9IG9wZW4oZm4sIE9f
UkRPTkxZKTsKICAgIGlmIChyZmQgPCAwKSB7CiAgICAgIHBlcnJvcigib3BlbiBybyIpOwogICAg
ICByZXR1cm4gMTsKICAgIH0KICAgIHVpbnQ2NF90IGlkeCA9IDA7CiAgICBzc2l6ZV90IHI7CiAg
ICB3aGlsZSAoKHIgPSByZWFkKHJmZCwgcmJ1Ziwgc2l6ZW9mIHJidWYpKSA+IDApIHsKICAgICAg
c2l6ZV90IGNudCA9IChzaXplX3QpciAvIDg7CiAgICAgIGZvciAoc2l6ZV90IGkgPSAwOyBpIDwg
Y250OyBpKyspIHsKICAgICAgICBpZiAocmJ1ZltpXSAhPSBpZHgpIHsKICAgICAgICAgIGZpcnN0
X2JhZCA9IChsb25nIGxvbmcpKGlkeCAqIDgpOwogICAgICAgICAgYmFkX3ZhbCA9IHJidWZbaV07
CiAgICAgICAgICBicmVhazsKICAgICAgICB9CiAgICAgICAgaWR4Kys7CiAgICAgIH0KICAgICAg
aWYgKGZpcnN0X2JhZCA+PSAwKQogICAgICAgIGJyZWFrOwogICAgfQogICAgY2xvc2UocmZkKTsK
CiAgICBpbnQgYnVnID0gKCh1aW50NjRfdClzdC5zdF9zaXplICE9IGV4cGVjdGVkKSB8fCAoZmly
c3RfYmFkID49IDApOwogICAgZmlsZXMrKzsKCiAgICBpZiAoYnVnKSB7CiAgICAgIHByaW50Zigi
XG4qKiogQ09SUlVQVElPTiBERVRFQ1RFRCBpbiAlcyAqKipcbiIsIGZuKTsKICAgICAgcHJpbnRm
KCIgIGJ5dGVzIGtlcm5lbCBzYWlkIGl0IHdyb3RlIChzdW0gb2YgQ1FFIHJlc3VsdHMpOiAlbGx1
XG4iLAogICAgICAgICAgICAgKHVuc2lnbmVkIGxvbmcgbG9uZylleHBlY3RlZCk7CiAgICAgIHBy
aW50ZigiICBhY3R1YWwgZmlsZSBzaXplOiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
JWxsdVxuIiwKICAgICAgICAgICAgICh1bnNpZ25lZCBsb25nIGxvbmcpc3Quc3Rfc2l6ZSk7CiAg
ICAgIHByaW50ZigiICBleHRyYSAoZHVwbGljYXRlZCkgYnl0ZXM6ICAgICAgICAgICAgICAgICAg
ICAgICAgJWxsZFxuIiwKICAgICAgICAgICAgIChsb25nIGxvbmcpc3Quc3Rfc2l6ZSAtIChsb25n
IGxvbmcpZXhwZWN0ZWQpOwogICAgICBpZiAoZmlyc3RfYmFkID49IDApIHsKICAgICAgICBwcmlu
dGYoIiAgZmlyc3QgbWlzbWF0Y2hpbmcgb2Zmc2V0OiAlbGxkICgweCVsbHgpICBwYWdlX2FsaWdu
ZWQ9JXNcbiIsIGZpcnN0X2JhZCwKICAgICAgICAgICAgICAgKHVuc2lnbmVkIGxvbmcgbG9uZylm
aXJzdF9iYWQsIChmaXJzdF9iYWQgJSA0MDk2ID09IDApID8gIllFUyIgOiAibm8iKTsKICAgICAg
ICBwcmludGYoIiAgICBleHBlY3RlZCB1NjQgJWxsdSBidXQgZm91bmQgJWxsdSAiCiAgICAgICAg
ICAgICAgICIoY29udGVudCBmcm9tIGJ5dGUgb2Zmc2V0ICVsbHUgcmVhcHBlYXJlZCBoZXJlKVxu
IiwKICAgICAgICAgICAgICAgKHVuc2lnbmVkIGxvbmcgbG9uZykoZmlyc3RfYmFkIC8gOCksICh1
bnNpZ25lZCBsb25nIGxvbmcpYmFkX3ZhbCwKICAgICAgICAgICAgICAgKHVuc2lnbmVkIGxvbmcg
bG9uZykoYmFkX3ZhbCAqIDgpKTsKICAgICAgfQogICAgICBwcmludGYoIiAgKGZpbGUga2VwdCBm
b3IgaW5zcGVjdGlvbilcbiIpOwogICAgICBpb191cmluZ19xdWV1ZV9leGl0KCZyaW5nKTsKICAg
ICAgcmV0dXJuIDA7CiAgICB9CiAgICB1bmxpbmsoZm4pOwogICAgaWYgKGZpbGVzICUgMjAgPT0g
MCkKICAgICAgZnByaW50ZihzdGRlcnIsICIuLi4lbGQgZmlsZXMgY2xlYW5cbiIsIGZpbGVzKTsK
ICB9CgogIHByaW50ZigiTm8gY29ycnVwdGlvbiBpbiAlZCBzICglbGQgZmlsZXMpLiBUcnkgbW9y
ZSB0aW1lLCBwYXJhbGxlbCBpbnN0YW5jZXMsICIKICAgICAgICAgIm9yIG1lbW9yeSBwcmVzc3Vy
ZS5cbiIsCiAgICAgICAgIHNlY29uZHMsIGZpbGVzKTsKICBpb191cmluZ19xdWV1ZV9leGl0KCZy
aW5nKTsKICBmcmVlKGJ1Zik7CiAgcmV0dXJuIDA7Cn0K
--000000000000dc1e61065371f8a6--

