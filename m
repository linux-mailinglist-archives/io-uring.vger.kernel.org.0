Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43DA46EB80B
	for <lists+io-uring@lfdr.de>; Sat, 22 Apr 2023 10:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjDVIk5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Apr 2023 04:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjDVIkz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Apr 2023 04:40:55 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7F11998;
        Sat, 22 Apr 2023 01:40:54 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 8A9C4C01F; Sat, 22 Apr 2023 10:40:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682152842; bh=lc2FLlya05jg7Sp4Tg62oG72PssqPEpEPxDspLUI7n8=;
        h=From:Subject:Date:To:Cc:From;
        b=rdmXRQAA16SWUp3ohnVzwHNDRSAmrM7cUAmXz/pxT/5sHD6oI79828+5O88tjxM6T
         /WlNpyHdaap2trQMTn8nJJuDXI71D5M7T1vPl+ItYX/TQZks2H1MHvzW3P91HBDOtg
         srarJGRzxOXxRvn0On0xjnfS6lhUVQH5GCUijIioiDc74e0vo1QgmEL5Y6pdWkn2al
         bdDnj/mKApsMuga9wQJhnNTCfjfPi3p9vJ7JaSu5z06YmrEzchqTzy/XpykXWSPV19
         GigUSK4IcXhnRDk0h6V+E84Ua+5p1S75HNEPc913SZSHaEnAJgcguTpTUOBXbHlubt
         OfyiQZtGSt7aw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id EE732C009;
        Sat, 22 Apr 2023 10:40:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682152841; bh=lc2FLlya05jg7Sp4Tg62oG72PssqPEpEPxDspLUI7n8=;
        h=From:Subject:Date:To:Cc:From;
        b=eW3emLSwideJRAg1STUeJ0FmwDO4frk5T3MeRtCa5kBc0YXbjSMjJamlgFU3IiTJz
         wX45BQko4qCfRnjvdyIjDCQwNGCHJ4BVFrz96mVAScbkqQokXbbZMwwnkyPzj3FRcH
         GwYTt9F2EH4jct5Hkw1TWwvE9bLkGiivK59xRXXZgrvAsR8UwpgfSTNF91tO0FEph+
         z3bELwg4yBuE/Bxq9u5Qq77OgXODX1riUc8kYxCz66b12UnEQtm86d315hERa47xGG
         xERKmDTCNPUC+nfiAtW5vOzMMIRtbwHYahPddVml8ieLT8A0SYN0sM3+iWXs0ornTm
         hzqeLBQQMmAtg==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id 4892991d;
        Sat, 22 Apr 2023 08:40:36 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH RFC 0/2] io_uring: add getdents support, take 2
Date:   Sat, 22 Apr 2023 17:40:17 +0900
Message-Id: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHGdQ2QC/zWNQQrCQAwAv1JyNrDGPYhXwQd4FZFsN25ziZJtR
 Sj9u9uCx4EZZoYqrlLh1M3g8tGqL2uw33XQD2xFUHNjoECHEIlwcrWCRcYsNlYk5nSMmWJghhY
 lroLJ2fphzTb78bdX4e3y1O92vMH1cob7svwAzr6pjIYAAAA=
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=2622;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=n3azlrwnUtWy2w+VGnEQyQWY3rWltNYuTzZU2fQE6UA=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkQ52ENRFRnIKYqxZCjOcfeev0IkqnaU+9Ojnzp
 teVbSbX7EiJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZEOdhAAKCRCrTpvsapjm
 cDdZD/9EkpCDzkqrMOSTVVnBJXMIclnGUVFFX/JH/Co80AxQOQPfkvLsWyZSmg6Rg5TPDZUIUvA
 ZYst/Zb33FN4LlSJwaDvFeZ5I5GNv1iirqV9Gg0bkfjdc9rZwX1GHecI1nxT5DueZSM6jG1Rwnp
 rD6Aaw7lvWlEe1v/+BtJvpqjUPA7VRKixAyYA6tsuDHEOrG1KBafsTxmlDfUsivqDErGUcttOmh
 RRDJntnAWXMb5wSas0UNpvDOfTroSfKyiYQnrgDQEOywnb1a3cG/h3IUHXtXJvVcZut2GdBktqg
 PQ4gh90jQpww2XYkOxoY2T/5h0RaDhTZZvTbxg57ARAc4HS87VD1SpuyjeOBlTetSDHZdkMR1Sl
 9vFWEZfjMkupbAorFch4cQawmBcaA76AGhqv+mlrpRnadjM1lfELb5PSZh4eLp297NgwpHjF6kR
 Q+ss5DiJGey/eYtJ1/8BSA8tLhNn8ttPDqWVZOFqWn/44kxm+s5HigujEXgnAgdcZRM0KClnJ9/
 fjDx2Oy7OW74yM3CqN0ZE4894zdQhpuIL2ek6cEzdNSMdPJ8afs4RUrxHXih1iSdkTuoxMkFZeP
 gmPswnwmlhBBuBVCLsUXvZJZkS3yXQ0iiQSqAo5nnBiHT7271M2mxsmSetBTirVetuw0tyR3YTF
 oefKPBurR4peHIQ==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an attempt to revive discussion after bringing it up as a reply
to the last attempt last week.

Since the problem with the previous attempt at adding getdents to
io_uring was that offset was problematic, we can just not add an offset
parameter: using different offsets is rarely useful in practice (maybe
for some cacheless userspace NFS server?) and more isn't worth the cost
of allowing arbitrary offsets: just allow rewind as a flag instead.
[happy to drop even that flag for what I care about, but that might be
useful enough on its own as io_uring rightfully has no seek API]

The new API does nothing that cannot be achieved with plain syscalls so
it shouldn't be introducing any new problem, the only downside is that
having the state in the file struct isn't very uring-ish and if a
better solution is found later that will probably require duplicating
some logic in a new flag... But that seems like it would likely be a
distant future, and this version should be usable right away.

To repeat the rationale for having getdents available from uring as it
has been a while, while I believe there can be real performance
improvements as suggested in [1], the real reason is to allow coherency
in code: applications using io_uring usually center their event loop
around the ring, and having the occasional synchronous getdents call in
there is cumbersome and hard to do properly when you consider e.g. a
slow or acting up network fs...
[1] https://lore.kernel.org/linux-fsdevel/20210218122640.GA334506@wantstofly.org/
(unfortunately the source is no longer available...)

liburing implementation:
https://github.com/martinetd/liburing/commits/getdents
(will submit properly after initial discussions here)

Previous discussion:
https://lore.kernel.org/all/20211221164004.119663-1-shr@fb.com/T/#m517583f23502f32b040c819d930359313b3db00c

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
Dominique Martinet (2):
      fs: split off vfs_getdents function of getdents64 syscall
      io_uring: add support for getdents

 fs/internal.h                 |  8 +++++++
 fs/readdir.c                  | 33 +++++++++++++++++++++-------
 include/uapi/linux/io_uring.h |  7 ++++++
 io_uring/fs.c                 | 51 +++++++++++++++++++++++++++++++++++++++++++
 io_uring/fs.h                 |  3 +++
 io_uring/opdef.c              |  8 +++++++
 6 files changed, 102 insertions(+), 8 deletions(-)
---
base-commit: 6a8f57ae2eb07ab39a6f0ccad60c760743051026
change-id: 20230422-uring-getdents-2aab84d240aa

Best regards,
-- 
Dominique Martinet | Asmadeus

