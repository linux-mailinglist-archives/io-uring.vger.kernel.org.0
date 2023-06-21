Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14127737A13
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 06:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjFUER3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 00:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjFUER2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 00:17:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE6E1706
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 21:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JchSKRnjMgCznYKknupBkF9TD5dHCGWbwIuW0emXZI4=; b=tMHC/V0CjqAApcPkt7OdBTnWii
        u8lwttOtZB5SpLkGTVtJoymLvrpoBahdF+yb7vkJeCvxw/qbZYLHI/69JW3McY9LgISmiAzC2TCdu
        0+L5myg3hUjvGOnSerZ8XYLAoR1e9qQxeF5jHUSKBYF6enkjqV2WcDS/RW9xVgmsHjrVh7DkVoLsl
        LvSpcPIOUydVUdBIq5RVJXFW392el6cMsIIIAh4eVklpl7K/0VSq+XYcbj/G57OiRpSGyu1bM7df4
        NNh0hMZEqfuCvaSp8QNCdqWB8/axYdpMHkK/XlUfvG/dvRNlUfva42bAQ6HBKIAGxO/+uIhgIi6fq
        P3hAekYQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qBpHZ-00DB42-22;
        Wed, 21 Jun 2023 04:17:25 +0000
Date:   Tue, 20 Jun 2023 21:17:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/net: silence sparse warnings on address space
Message-ID: <ZJJ51Ya+i/dtGU6E@infradead.org>
References: <222f3e9e-62a4-a57d-b14c-c8e9185ca1ae@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <222f3e9e-62a4-a57d-b14c-c8e9185ca1ae@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 20, 2023 at 04:55:05PM -0600, Jens Axboe wrote:
> Rather than assign the user pointer to msghdr->msg_control, assign it
> to msghdr->msg_control_user to make sparse happy. They are in a union
> so the end result is the same, but let's avoid new sparse warnings and
> squash this one.

Te patch looks good, but I think "silence sparse warning" is a horrible
way to write a commit message.  Yes, you're silencing sparse, but sparse
only complains because we have a type mismatch.

So the much better Subject would be something like: 

io_uring/net: use the correct msghdr union member in io_sendmsg_copy_hdr

Use msg_control_user to read the control message in io_sendmsg_copy_hdr
as we expect a user pointer, not the kernel pointer in msg_control.
The end result is the same, but this avoids a sparse addres space
warning.

With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(and it's really time we ger the __user and __bitwise annotations
checked by hte actual compiler..)
