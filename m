Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9318459890B
	for <lists+io-uring@lfdr.de>; Thu, 18 Aug 2022 18:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344835AbiHRQhR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Aug 2022 12:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244557AbiHRQhQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Aug 2022 12:37:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D78BE4D0;
        Thu, 18 Aug 2022 09:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DD21615BC;
        Thu, 18 Aug 2022 16:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA40C433D6;
        Thu, 18 Aug 2022 16:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660840634;
        bh=QN6pzB7ts62QG1T5xnZB3fjWg90F6T1cD+qyxYHqBb8=;
        h=Date:From:To:Cc:Subject:From;
        b=JVfBeI4zpmSnChBDL1T16z+k6i5GDlJ7gtj3IEUnnXh0RtwNtGG6F21fFYxJgAuwq
         7GAJ2aBQ7kOzn5/OEk7jhOVldc7H058DmauGaYY8piDhB6iXomLTPEqHLjVelLAyDh
         UChQbn6EUCUAHH7vQB/e7YncD3pos+u7+rdApe62brDyEh2GiZN1s2bMLFMS4/uRf6
         4SV9yL/R2pUP5Y7sAT5VHdnLJAg9b99YXf3b3YnBBYWB666pM7ekQTUA7P7wbsZcx8
         JscaN30AOX0GtJ7I1+zAe+l9In2GPNPs68H7Yb3iC5WD7qpOP31VkR+UKNzccWH+0A
         8hSTagrhTwnGw==
Date:   Thu, 18 Aug 2022 09:37:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     fstests <fstests@vger.kernel.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, willy@infradead.org, Stefan Roesch <shr@fb.com>
Subject: generic/471 regression with async buffered writes?
Message-ID: <Yv5quvRMZXlDXED/@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi everyone,

I noticed the following fstest failure on XFS on 6.0-rc1 that wasn't
there in 5.19:

--- generic/471.out
+++ generic/471.out.bad
@@ -2,12 +2,10 @@
 pwrite: Resource temporarily unavailable
 wrote 8388608/8388608 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-RWF_NOWAIT time is within limits.
+pwrite: Resource temporarily unavailable
+(standard_in) 1: syntax error
+RWF_NOWAIT took  seconds
 00000000:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
 *
-00200000:  bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
-*
-00300000:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
-*
 read 8388608/8388608 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)

Is this related to the async buffered write changes, or should I keep
looking?  AFAICT nobody else has mentioned problems with 471...

--D
