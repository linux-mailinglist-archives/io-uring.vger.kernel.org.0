Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C4653DD90
	for <lists+io-uring@lfdr.de>; Sun,  5 Jun 2022 20:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbiFESKX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jun 2022 14:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346778AbiFESKX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jun 2022 14:10:23 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEB94DF73;
        Sun,  5 Jun 2022 11:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rXrnuUwPk7D+tWHtBEXzNHtRzjQTrGNF6SniWI3rolg=; b=SM5YTwjOrNCcZ5nHpGy3KnPKrL
        6AGfE+wFSgV0rRUMANoaJZ7td+3OVw4zzokyUM8EkYIcRxkM6E07uMG/YiDHQwkdVLYU3sbyI7kdz
        v2qKF5cJXDi7qS9cpKBMMuCQkIM7XLDNRNOTxHVy4kbOYbRh4rsZEpgk81dwdc2HeK9jVAgLBqdLK
        6ZKaJco1G6pkxbEemvCEQYMNxL5Tum7M9TEHyPYIZPcV6QxPf6pPVDPsdvijrjqWs59kGwVAGjUq1
        1Ju7kOkmxzd8/cOkdS0I4a3AFm6UQb8PwCB0WDXCMTCZRjQLNXluK+qEqDBsEaUJvZqBFJI73swJI
        C09VUpmQ==;
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nxuhZ-003qEO-3F; Sun, 05 Jun 2022 18:10:13 +0000
Date:   Sun, 5 Jun 2022 18:10:13 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     syzbot <syzbot+47dd250f527cb7bebf24@syzkaller.appspotmail.com>
Cc:     arve@android.com, asml.silence@gmail.com, axboe@kernel.dk,
        brauner@kernel.org, gregkh@linuxfoundation.org, hdanton@sina.com,
        hridya@google.com, io-uring@vger.kernel.org,
        joel@joelfernandes.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, maco@android.com, surenb@google.com,
        syzkaller-bugs@googlegroups.com, tkjos@android.com
Subject: Re: [syzbot] KASAN: use-after-free Read in filp_close
Message-ID: <YpzxhRLKyETOtUeH@zeniv-ca.linux.org.uk>
References: <000000000000fd54f805e0351875@google.com>
 <00000000000061dcef05e0b3d4e3@google.com>
 <YpzWvkNcq0llgdkW@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpzWvkNcq0llgdkW@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jun 05, 2022 at 04:15:58PM +0000, Al Viro wrote:
> Argh...  I see what's going on.  Check if the following fixes the problem,
> please.

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git work.fd
