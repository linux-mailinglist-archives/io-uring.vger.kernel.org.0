Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210A76C233C
	for <lists+io-uring@lfdr.de>; Mon, 20 Mar 2023 21:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjCTU5K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 16:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjCTU5J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 16:57:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB623C10;
        Mon, 20 Mar 2023 13:56:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34B21B8100E;
        Mon, 20 Mar 2023 20:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC9BC433EF;
        Mon, 20 Mar 2023 20:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679345812;
        bh=kFs7V0IpcMLHd4kjh+6jT4C97CouHl8tC7dSXw/CdNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CVVa5S3wGOb/dZEZkalkdl+aTbABvYxMyPYlBnkwf9QI23Sci6LbrPqS6/e8PqZpW
         0i6ygiLK1b5i1IwBRknE2OBxtF49nfUpXIskwIUsaCHxMkKY4itZOzo0DaP4g5Fxkb
         duiDHiJyYF4vTsdccdNZA7TGOnueFEsE0CV0CK6cekKx2BnmYXPcWXMZp11YbeXqXD
         QlbNQZxCaSj/4yQYi++P982ECM89zH7rnpihfvXo9Ku1oEAds4I55WQF8V910Fcevu
         dlCuQRnMN6wTI3n121i7UPKTOVgSIMHHKaR1cfA9jizmRmTlPxa35cTUe273z+4e/F
         SCuYndqoRUd+A==
Date:   Mon, 20 Mar 2023 14:56:49 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Keith Busch <kbusch@meta.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCHv2] blk-mq: remove hybrid polling
Message-ID: <ZBjIkXZLR2fSOyqX@kbusch-mbp.dhcp.thefacebook.com>
References: <20230320194926.3353144-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320194926.3353144-1-kbusch@meta.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 20, 2023 at 12:49:26PM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> io_uring provides the only way user space can poll completions, and that
> always sets BLK_POLL_NOSLEEP. This effectively makes hybrid polling dead
> code, so remove it and everything supporting it.

Hybrid polling was effectively killed off with 9650b453a3d4b1, "block: ignore
RWF_HIPRI hint for sync dio", so we could add a "Fixes: " for that. It was
still potentially reachable through io_uring until d729cf9acb93119, "io_uring:
don't sleep when polling for I/O", but hybrid polling probably should not have
been reachable through that async interface from the beginning.
