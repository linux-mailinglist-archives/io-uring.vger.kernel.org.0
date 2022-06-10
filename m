Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD74545BF1
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 07:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243604AbiFJF4B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 01:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239380AbiFJF4B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 01:56:01 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A60D33344
        for <io-uring@vger.kernel.org>; Thu,  9 Jun 2022 22:55:59 -0700 (PDT)
Message-ID: <6641baea-ba35-fb31-b2e7-901d72e9d9a0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654840557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rTfBAflgzwq7qVAmpRwcLMrMpFpwKFQzllV8hjm0tJw=;
        b=MzD4sSX7+lOR/46Gav7gEFKFS+h+n3C+Gt4x8vYLju61NjFVXIR+pY8PIPaEvOl1C0pWcv
        xdzmMeGKSlKREZGIZjBSbpduNsXurNKh5Uc86oYBXeTocBL+sIfmAN3ZvuGEBqMb+ohuR8
        lU4PJPC9J48Y3D4vamOZLODvPya49EM=
Date:   Fri, 10 Jun 2022 13:55:51 +0800
MIME-Version: 1.0
X-Mozilla-News-Host: news://nntp.lore.kernel.org:119
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
Subject: [RFC] support memory recycle for ring-mapped provided buffer
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi all,

I've actually done most code of this, but I think it's necessary to
first ask community for comments on the design. what I do is when
consuming a buffer, don't increment the head, but check the length
in real use. Then update the buffer info like
buff->addr += len, buff->len -= len;
(off course if a req consumes the whole buffer, just increment head)
and since we now changed the addr of buffer, a simple buffer id is
useless for userspace to get the data. We have to deliver the original
addr back to userspace through cqe->extra1, which means this feature
needs CQE32 to be on.
This way a provided buffer may be splited to many pieces, and userspace
should track each piece, when all the pieces are spare again, they can
re-provide the buffer.(they can surely re-provide each piece separately
but that causes more and more memory fragments, anyway, it's users'
choice.)

How do you think of this? Actually I'm not a fun of big cqe, it's not
perfect to have the limitation of having CQE32 on, but seems no other
option?

Thanks,
Hao
