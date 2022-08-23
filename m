Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975A259E6E7
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 18:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244152AbiHWQUt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 12:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244396AbiHWQUL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 12:20:11 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3711226F4E7;
        Tue, 23 Aug 2022 05:40:15 -0700 (PDT)
Received: from localhost.localdomain (unknown [125.160.110.187])
        by gnuweeb.org (Postfix) with ESMTPSA id 6F285809CD;
        Tue, 23 Aug 2022 11:46:06 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661255169;
        bh=iXY58qpE+3plE5TT69M+Y8nbwlXotZalLJMbvYrNNig=;
        h=From:To:Cc:Subject:Date:From;
        b=Qv3cHjGppNT7LSVrgcgrEMrs1TOsZ1zxM8GN2ji1GFAB/JboqoWlDxamZe1dx+hgv
         MyOqLlH3aGT9x/EPJgGc+FgYGjqoc6Fmei9YfT6HrSLvjV8KEbIIHX01eEE1zGgBSZ
         psVPmFTKBJEmvf0Biii9zWL+rsTzP47KBAcvFupPQeqaKIKITTk1p3apO/0pgqTkJZ
         V2I/zxmWWMadLnTiCobrbe0FZb4s3zYPxldxhDMW0M46usa3U35NoMaQKt/Zmqlxo2
         tUBMvAwCb8L3twq+nXiMhLmR52ek+D4VFxy1+Cp7D/3jCA69foyN2LCwf+cSVr5ArN
         /CBHxpqrtwukA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Kanna Scarlet <knscarlet@gnuweeb.org>
Subject: [PATCH 0/2] Maintainer and uapi header update
Date:   Tue, 23 Aug 2022 18:45:47 +0700
Message-Id: <20220823114337.2858669-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hi Jens,

There are two patches in this series.

1) MAINTAINERS: Add `include/linux/io_uring_types.h`.

File include/linux/io_uring_types.h doesn't have a maintainer, add it
to the io_uring section.

2) io_uring: uapi: Add `extern "C"` in io_uring.h for liburing.

On Tue, 28 Jun 2022 10:12:27 -0600, Jens Axboe wrote:
> On 6/28/22 10:10 AM, Ammar Faizi wrote:
>> Or better add that to the kernel tree as well, it won't break
>> the kernel because we have a __cplusplus guard here.
>> 
>> Jens what do you think?
>
> It'd be nice to keep them fully in sync. If I recall correctly, the only
> differences right now is that clause, and the change to not using a zero
> sized array at the end of a struct (which is slated for the kernel too).

^ Do that.

Ref: https://lore.kernel.org/io-uring/f1feef16-6ea2-0653-238f-4aaee35060b6@kernel.dk

Make it easy for liburing to integrate uapi header with the kernel.
Previously, when this header changes, the liburing side can't directly
copy this header file due to some small differences. Sync them.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Dylan Yudaken <dylany@fb.com>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (2):
  MAINTAINERS: Add `include/linux/io_uring_types.h`
  io_uring: uapi: Add `extern "C"` in io_uring.h for liburing

 MAINTAINERS                   | 1 +
 include/uapi/linux/io_uring.h | 8 ++++++++
 2 files changed, 9 insertions(+)


base-commit: 3f743e9bbb8fe20f4c477e4bf6341c4187a4a264
-- 
Ammar Faizi

