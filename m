Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468DE4B731B
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 17:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240614AbiBOPmm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Feb 2022 10:42:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242429AbiBOPm3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Feb 2022 10:42:29 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BC6D0B4A
        for <io-uring@vger.kernel.org>; Tue, 15 Feb 2022 07:37:28 -0800 (PST)
Received: from integral2.. (unknown [36.68.63.145])
        by gnuweeb.org (Postfix) with ESMTPSA id 103AC7E25A;
        Tue, 15 Feb 2022 15:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1644939433;
        bh=/FgHNUez6EN6l8BVNLeQey/0NJBAPNOH5gNwnrHSUYY=;
        h=From:To:Cc:Subject:Date:From;
        b=Fj/XnGaLCTnNfrLrdQWQOkayco2kgwpfjpzEShiJ5HOp1oZIN+I4U5osHi6C91aUl
         ni/589qjn5QNvmv/QNasxEFsUVrj7OcJfVKwm4CznruurYIPZ41KZq/2eh6oe+wVtX
         oSvVI7SUAuXqYZJOwydqnWRnVYyg40t8ItDF7sTWtxrxkXuqHrq8oIzTnuNy9aq7V6
         mpCt2zYsYkUjWyW5CTtboyeEFacixAue8moVd9bY+SYh22kQjSDU7gGF03F+6T8LWM
         Isqts1em04J5dBS9fgoqAvrWoYNaU2D11vFkHuzHiQ/NTClCFoojzKoKjf0zdHai4+
         Ar/ko/8uvUSuw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Arthur Lapz <rlapz@gnuweeb.org>, Nugra <nnn@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Nugra <richiisei@gmail.com>
Subject: [PATCH liburing v1 0/2] Support busybox mktemp and add x86-64 syscall macros
Date:   Tue, 15 Feb 2022 22:36:49 +0700
Message-Id: <20220215153651.181319-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

Two patches in this series.
1) Support busybox mktemp from Nugra.
-------------------------------------
Busybox mktemp does not support `--tmpdir`, it says:
    mktemp: unrecognized option: tmpdir

It can be fixed with:
	1. Create a temporary directory.
	2. Use touch to create the temporary files inside the directory.
	3. Clean up by deleting the temporary directory.

2) Create syscall __do_syscall{0..6} macros from Alviro.
----------------------------------------------------------
Reduce arch dependent code by creating __do_syscall{0..6} macros.
These macros are made of inline Assembly x86-64. Use them to invoke
syscall via __sys* functions. By using this design, we don't have to
code in inline Assembly again when adding a new syscall.

Tested on Linux x86-64, all test passed, but rsrc_tags timedout.

Cc: Arthur Lapz <rlapz@gnuweeb.org>
Cc: Nugra <nnn@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Nugra <richiisei@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Alviro Iskandar Setiawan (1):
  arch/x86: Create syscall __do_syscall{0..6} macros

Nugra (1):
  configure: Support busybox mktemp

 configure              |  13 ++-
 src/arch/x86/syscall.h | 242 +++++++++++++++++++++--------------------
 2 files changed, 132 insertions(+), 123 deletions(-)


base-commit: ea1e6f8c4e9180bde1844bd56a072bd4c1afae3e
-- 
2.32.0

