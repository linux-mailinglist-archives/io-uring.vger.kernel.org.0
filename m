Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE142601DF
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 19:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbgIGROB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 13:14:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31151 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731007AbgIGRN6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 13:13:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599498836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uZ41vh8cdHT9hgDZ+Na4xPNEsTnHM3xMcB31R6cASEU=;
        b=Z5y6kgEG3haId6kwsooIKzE5bW3CmtbwF+QXpWZiQVcD7PeFTAE7EynHCNT/7SPiuZnHMM
        QYRRlD1LuXpsm8CoEBschUew6yDpCU0j8eS/EKGlhuTGZqLG4g9wb54fRlWSyx96biPV+P
        wkSs4p4kjjg5ICzrgzMtkN4YQ3t8XQA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-X83moJzWPs6CT12_4-M83A-1; Mon, 07 Sep 2020 13:13:54 -0400
X-MC-Unique: X83moJzWPs6CT12_4-M83A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65E7AEF4E3;
        Mon,  7 Sep 2020 17:13:53 +0000 (UTC)
Received: from work (unknown [10.40.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AA74C7DA4E;
        Mon,  7 Sep 2020 17:13:52 +0000 (UTC)
Date:   Mon, 7 Sep 2020 19:13:49 +0200
From:   Lukas Czerner <lczerner@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 2/2] runtests: add ability to exclude tests
Message-ID: <20200907171349.bsnw3r4diak3nnab@work>
References: <20200907132225.4181-1-lczerner@redhat.com>
 <20200907132225.4181-2-lczerner@redhat.com>
 <bfdf7e5e-06b6-f2e3-7f52-d2a6a32d719e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfdf7e5e-06b6-f2e3-7f52-d2a6a32d719e@kernel.dk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 07, 2020 at 10:21:56AM -0600, Jens Axboe wrote:
> On 9/7/20 7:22 AM, Lukas Czerner wrote:
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Is there a cover letter and/or 1/2 patch that didn't go out?
> 

There is 1/2 patch. Not sure why it didn't go through. I'll recheck and
try again.

-Lukas

> -- 
> Jens Axboe
> 

