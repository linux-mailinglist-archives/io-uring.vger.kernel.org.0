Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892804397F8
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 15:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhJYOBE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 10:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbhJYOBE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 10:01:04 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EB9C061745
        for <io-uring@vger.kernel.org>; Mon, 25 Oct 2021 06:58:40 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1635170317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kBpkLHftOVan7gvGuZV7n7HxmW1TFZ8TO36LgFfjOck=;
        b=wj7u+806NjETU25xQw/wGpL7Ot4VdfUH49O/hVnC6RVOA+EHe6IMUJu7Bn6Wh27C5d6A0L
        uF+Y1mE3CxfFPhev5OaiPE7vGkYQi4rYTI8U6D8NXS6NY8i7Xv4sT3ZX7KePKv5g//sIkX
        TS2M5DHJLhlOy3zowNTOY0enKTd6aBqubx76Tg7vbF+44bfoBlWKYLfAkDIGcL3cdTmNMx
        mW9trkd0buY14jlJXybzo+7Iad30WzF/zJmU1pUNDLEldn2L4RDz1In3bs5jNiNys+ZOke
        rlemWmf9suJRoRJptzolEY3peT9eChRG5l3MXPhbKAyU03jVr4M9/tJeQfdCWg==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 25 Oct 2021 15:58:33 +0200
Message-Id: <CF8JHZUUYC1O.3DU8635RE8FSX@taiga>
Subject: Is IORING_REGISTER_BUFFERS useful given the current default
 RLIMIT_MLOCK?
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     <io-uring@vger.kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The current default for RLIMIT_MLOCK is set to 64 KiB. This is not much!
This limit was set to this value in 2008 at the request of GnuPG.

I understand that the main audience of io_uring is high-performance
servers and such, where configuring the rlimits appropriately is not a
particularly burdensome ask. However, this dramatically limits the
utility of IORING_REGISTER_BUFFERS in the end-user software use-case,
almost such that it's entirely pointless *without* raising the mlock
rlimit.

I wonder if we can/should make a case for raising the default rlimit to
something more useful for $CURRENTYEAR?
