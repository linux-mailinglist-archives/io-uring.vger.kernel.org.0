Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448FF2EB5E2
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 00:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbhAEXJD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jan 2021 18:09:03 -0500
Received: from out1.migadu.com ([91.121.223.63]:19766 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbhAEXJC (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 5 Jan 2021 18:09:02 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2021 18:09:02 EST
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dagur.eu; s=default;
        t=1609887613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zj8WuU2kamLsajIPuqaft90bdFQuTNGJlTxFBqw8xtY=;
        b=0JBUgcaBgeHCmaB2RCvl64Yj/1QLb3q+HKAqY35CmXcDZ6aVzvQ1JmHuPbae+k3cMuFUFj
        0ldR3q+at0lXaMFQ6Ce97AehwXrY1WfvshI1CijT/+iizH2toaaE9lbdyZn5u+wfQfo6qL
        ybQiKDd5KZHdD02edJBC9x9StJ9ZCcE=
From:   arni@dagur.eu
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
Subject: [PATCH] io_uring: Add vmsplice support
Message-Id: <20210105225932.1249603-1-arni@dagur.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: arni@dagur.eu
Date:   Tue, 05 Jan 2021 23:00:13 GMT
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset is a followup from my last email, which may be found at
https://lore.kernel.org/io-uring/20210103222117.905850-1-arni@dagur.eu/

Thanks for you feedback, Jens. I have modified the test app on my end as
well, and it now looks like the following
https://gist.githubusercontent.com/ArniDagur/3392a787e89e78ba8ff739ff0f8476d5/raw/d01d19bb6fdc3defea59ae7c2a2c3d29682d8520/main.c

As you suggested, I now always return -EGAIN when force_nonblock is set.
In addition, req_set_fail_links() is now called when less than the
entirety of the buffer is spliced, and io_req_complete() is called at
the end.


