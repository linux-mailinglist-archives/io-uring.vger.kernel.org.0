Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20541C3EB9
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 17:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgEDPjm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 11:39:42 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.228]:27271 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728294AbgEDPjl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 11:39:41 -0400
X-Greylist: delayed 1491 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 May 2020 11:39:41 EDT
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 27A80400C80C0
        for <io-uring@vger.kernel.org>; Mon,  4 May 2020 10:14:48 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id VcnwjVw4uVQh0VcnwjcNxS; Mon, 04 May 2020 10:14:48 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0aRQZfEcxHyBj7xnDiHsle71WyIV/i7sE6OjfEdSZt4=; b=pzLzkbHmwXQ0GeUH5+6kvnEZha
        ZteJlMux6TZSH/AikoPvYp7CfasYeff9LU8ME9UZabFJYAmM7iDAk7Dtzd1vcIfYWHlGDQY9xj3GQ
        5RQhnx3brUKeJUoSly0atiiJYFBRueb3lIe9AnwHP3GZhpKpOkex+UUG7cURDZKkkyZSOGI34bbT+
        sMAWxPOItDndSR3yBtlBp4nQrF6rnfpHM92U0XDIxpf0NELlZFcENRtKk5veV6UZSCEUExxMFhIkX
        3+fCN6loSsmy2E8ZSbIySndGn2+G7B46iRqgNRMUeAzgUzoe/VZDGtBaJKHJpAgPBPYX3K56srXBL
        OLWqf/Qg==;
Received: from [189.207.59.248] (port=60896 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jVcnv-003tgs-Q8; Mon, 04 May 2020 10:14:47 -0500
Date:   Mon, 4 May 2020 10:19:12 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] io_uring: Remove logically dead code in io_splice
Message-ID: <20200504151912.GA22779@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.207.59.248
X-Source-L: No
X-Exim-ID: 1jVcnv-003tgs-Q8
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.207.59.248]:60896
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 14
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In case force_nonblock happens to be true, the function returns
at:

 2779         if (force_nonblock)
 2780                 return -EAGAIN;

before reaching this line of code. So, the null check on force_nonblock
at 2785, is never actually being executed.

Addresses-Coverity-ID: 1492838 ("Logically dead code")
Fixes: 2fb3e82284fc ("io_uring: punt splice async because of inode mutex")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e5dfbbd2aa34..4b1efb062f7f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2782,7 +2782,7 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
 	ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
-	if (force_nonblock && ret == -EAGAIN)
+	if (ret == -EAGAIN)
 		return -EAGAIN;
 
 	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
-- 
2.26.0

