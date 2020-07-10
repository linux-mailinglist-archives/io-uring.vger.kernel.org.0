Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A48721B997
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 17:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgGJPcw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 11:32:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55504 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgGJPcv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 11:32:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AFGfbR091218;
        Fri, 10 Jul 2020 15:32:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=noRFkj+OQDbBA2VGp4VYO7xlUC6XPPINL2vE+AEdyMs=;
 b=vP7ocyP6G8yyQHxRakpibhyM1nz+c9fv0HuXARINt0xwJGXnneDkHMx3/I9UqlGe0CDP
 a0c+6nMpavkOsyuS6N4K9cIu548k77Y6U9ObDCmG20VB/170q6aRnsMcG6RUGknHH8+r
 gL78ARsbKlZWOO088PwfuNNLnqotvlsP5YvtRQJxhu7FeUTuznVOMKzuBjhEsmUA6par
 mSbZ6IlrmXcxxdg05cm4SVb2jZhgvAcpfeTaGBpmpkOaSxijP2Ub+hrjs8eVFN3bAZY+
 l6reAtwEC+XXnRCO4zxYIo4Q+OIOn2eb8IUP/uHGiLO3288Gxmm5oKDZYPQCs+3Iq53c FQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 325y0ar568-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jul 2020 15:32:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AFHMZH146270;
        Fri, 10 Jul 2020 15:32:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 325k3k25k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jul 2020 15:32:17 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06AFWDQx014888;
        Fri, 10 Jul 2020 15:32:13 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jul 2020 08:32:13 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id 58EB86A00F1; Fri, 10 Jul 2020 11:33:09 -0400 (EDT)
Date:   Fri, 10 Jul 2020 11:33:09 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, Aleksa Sarai <asarai@suse.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH RFC 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200710153309.GA4699@char.us.oracle.com>
References: <20200710141945.129329-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710141945.129329-1-sgarzare@redhat.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9678 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9678 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100105
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

.snip..
> Just to recap the proposal, the idea is to add some restrictions to the
> operations (sqe, register, fixed file) to safely allow untrusted applications
> or guests to use io_uring queues.

Hi!

This is neat and quite cool - but one thing that keeps nagging me is
what how much overhead does this cut from the existing setup when you use
virtio (with guests obviously)? That is from a high level view the
beaty of io_uring being passed in the guest is you don't have the
virtio ring -> io_uring processing, right?

Thanks!
