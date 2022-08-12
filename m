Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5FF59173E
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 00:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbiHLWYC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 18:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiHLWYB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 18:24:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F1111475
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:24:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8EB461866
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 22:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8B8C433D6;
        Fri, 12 Aug 2022 22:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660343040;
        bh=ilteXwsaeIEcwJN1F0UGR+WiTRQB+xNXuiqjx0m+XRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DmP2Eum7FgF4jy2y4nU9DQ90VgYKgdJAGdfYrxRT9mOFbEqx95jWPcGDUFagNaQm1
         yNxesnTmM4WskQcaa7NcmEgE/pYNKbLRWTtcOpk86ZhUSr9+sgFM8wv31c01m9gDEy
         GEjpOpQPHzVygKEn3qp7cixBpY1OZv/pzynpn3oISnbVBF/ex8GTRk/rHAyrtThfqF
         E9nHwQMMMWNZPo1XaNveS5exY2FIiH72KQNzx+7AA4E9E9Trk5lmIEaVPjJxiJU7r/
         3c0KoiR5Mp9ew3KrvBGrURsClwROAv1S3c6POKeNwoxIYGcKgi5gHmvlv0VhdMvGEZ
         pWsCaYJ2QFiyw==
Date:   Fri, 12 Aug 2022 16:23:56 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
Message-ID: <YvbS/OHMJowdz+X3@kbusch-mbp.dhcp.thefacebook.com>
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk>
 <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk>
 <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
 <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
 <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
 <bb3d5834-ebe2-a82d-2312-96282b5b5e2e@kernel.dk>
 <e9747e47-3b2a-539c-c60b-fd9ccfe5c5e4@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9747e47-3b2a-539c-c60b-fd9ccfe5c5e4@kernel.dk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 12, 2022 at 04:19:06PM -0600, Jens Axboe wrote:
> On 8/12/22 4:11 PM, Jens Axboe wrote:
> > For that one suggestion, I suspect this will fix your issue. It's
> > obviously not a thing of beauty...
> 
> While it did fix compile, it's also wrong obviously as io_rw needs to be
> in that union... Thanks Keith, again!

I'd prefer if we can get away with forcing struct kiocb to not grow. The below
should have the randomization move the smallest two fields together so we don't
introduce more padding than necessary:

---
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5113f65c786f..ef7b277cb7f3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -347,8 +347,10 @@ struct kiocb {
 	loff_t			ki_pos;
 	void (*ki_complete)(struct kiocb *iocb, long ret);
 	void			*private;
-	int			ki_flags;
-	u16			ki_ioprio; /* See linux/ioprio.h */
+	struct {
+		int			ki_flags;
+		u16			ki_ioprio; /* See linux/ioprio.h */
+	};
 	struct wait_page_queue	*ki_waitq; /* for async buffered IO */
 	randomized_struct_fields_end
 };
--
