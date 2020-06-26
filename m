Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F8A20BA84
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 22:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgFZUrZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 16:47:25 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:20972 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFZUrZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 16:47:25 -0400
Date:   Fri, 26 Jun 2020 20:47:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=remexre.xyz;
        s=protonmail; t=1593204443;
        bh=e03K4pHUjuSJSeHKZo5NDisdlejkUTAAwR4ZHsvU6+4=;
        h=Date:To:From:Reply-To:Subject:From;
        b=SdbA/foTkOzdnRxgOkuKlv5/kQ3QclkecZtKS0WzAsfCu34FhF45vVp2oUQOixOjO
         pTs1N0RIkV594KYpvHXXGzCWaoOfWbtkbaEQGbNblvNOtp3CgRLxR0LVOrc8hX8W6k
         fC2ZNV4r4FihZxOm/u9SVJc91HVusL6T9g7lqWag=
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
From:   Nathan Ringo <nathan@remexre.xyz>
Reply-To: Nathan Ringo <nathan@remexre.xyz>
Subject: sendto(), recvfrom()
Message-ID: <bRmxY0zzqGcGWE4Xg-O3jlU42WtEEMUb4iGvfOvesLybmoDNJ242_9phm-DHLM8zJzu7C63iKCZq4ZJLcrYXnuVewHvCgiO21tW2CSuabnE=@remexre.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.3 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,PDS_OTHER_BAD_TLD shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Would adding IORING_OP_{SENDTO,RECVFROM} be a reasonable first kernel
contribution? I'd like to write a program with io_uring that's listening
on a UDP socket, so recvfrom() at least is important to my use-case.

--
Nathan Ringo

