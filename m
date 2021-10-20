Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769774347DB
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 11:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhJTJYK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 05:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhJTJYJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 05:24:09 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167ADC06174E
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 02:21:48 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1634721706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=twxs1S/avkJ6Bt5mWfJ9dN3ihCvf/s/lgxcOUNZUFGI=;
        b=tN9Ha7R607u9pkD35MFWlgrUl1vGjHH6/EyogZVJp3966UyHPh1DJ30UQiqhYiXzXzGOTl
        OtT1YE25ycO3VkMqPwQSBP72AG09dqTOfhPwE7pMIMc6hESFBhPpK+lgTp67lmTAhf/5cB
        hXDH9yK0vKJ2g+NWgeOBz7WjX1m0Tv+x6jmL+s5ZHiunC6Vji3+M+ozCARi4FKcuyUadch
        OuIbmOst/atCn6zf7CKxLrVBz4kME/HgQWB8mEKBJ/+pDZ2Ea5XPAr6iXSn+td4YUscpyM
        RjAaA2zRRWeKmV6HZsMoaKQ5Ou72ZnPkp8rrb0g3NPlxmskHR/WfgL0wzG0Q0w==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 20 Oct 2021 11:21:43 +0200
Message-Id: <CF44HAZOCG3O.1IGR35UF76JWC@taiga>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     <io-uring@vger.kernel.org>
Subject: Polling on an io_uring file descriptor
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I would like to poll on an io_uring file descriptor to be notified when
CQE's are available, either via poll(2) or IORING_OP_POLL_ADD. This
doesn't seem to work on 5.10. Is this feasible to add support for?
