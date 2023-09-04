Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563237914D8
	for <lists+io-uring@lfdr.de>; Mon,  4 Sep 2023 11:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350388AbjIDJhv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Sep 2023 05:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbjIDJhu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Sep 2023 05:37:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80741BF;
        Mon,  4 Sep 2023 02:37:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F904B80D77;
        Mon,  4 Sep 2023 09:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93463C433C8;
        Mon,  4 Sep 2023 09:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693820264;
        bh=0Ik33Yv016rCo6eme+x5SGC/ICJgl1qh75BuncMETlY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MNfTeWYfzXJeH0UCFNOg/c0GoULakcQjn9VfWyUVERq4CF/GjwF0GqntM6SDP3JOZ
         HmWkjCX0fWCD0NTKEH60CwhxbThIKelKwPhRfwlUENM6XFv/l0IS1o7emDiU3H4sDY
         gBdwt4UfhIf4zsES+N5uNZjpkjwhbVWi5Ab2OqyRyLp8TjL/51+ZKLnqqjiaytC1AP
         9u5Hfrd311fN8uwk04vQvyQIEWGhHff8ReEnBJpxmNpAhf+mTtmR61x3ITKiyEvg8N
         IV2NFewIfJBwDwTjOygKdvYQVenO5HAiINSRfH2ApWi+qCWlvA9GPQvzS06JcPFvo3
         SRfjpmfcvOp9Q==
Date:   Mon, 4 Sep 2023 11:37:35 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-cachefs@redhat.com,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mtd@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 10/11] vfs: trylock inode->i_rwsem in iterate_dir() to
 support nowait
Message-ID: <20230904-qualm-molekular-84b4d1c79769@brauner>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-11-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230827132835.1373581-11-hao.xu@linux.dev>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Aug 27, 2023 at 09:28:34PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Trylock inode->i_rwsem in iterate_dir() to support nowait semantics and
> error out -EAGAIN when there is contention.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---

Unreviewable until you rebased on -rc1 as far as I'm concerned because
the code in here changed a lot.
