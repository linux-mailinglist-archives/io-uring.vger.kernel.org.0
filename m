Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B283E26D20D
	for <lists+io-uring@lfdr.de>; Thu, 17 Sep 2020 06:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgIQEHN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Sep 2020 00:07:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbgIQEHM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Sep 2020 00:07:12 -0400
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 00:07:11 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600315630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zRnjsjM+bZcokNABizcWKx42JBN6OfYS2zb31dj0Zo0=;
        b=Y5KQ/mSP5U+1PZXAY/bWL55dKC1BWZxybf8BFxRLVpktn1HNZpWZGJWj5YF0DLprNbvlZs
        jpNkFc3AvDokv8KUWTkj0VJFFy0GoHqhOKcFWf7bN8qZ7VSzuJl61U6etNpIhGQDkF3Ppb
        kBeRRoxmRIMt/7AioezdBMg8VfHFCwA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-s_z3h0ZSMiOQtw3PLgPB8A-1; Wed, 16 Sep 2020 23:51:48 -0400
X-MC-Unique: s_z3h0ZSMiOQtw3PLgPB8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49B52427F2;
        Thu, 17 Sep 2020 03:51:47 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B834E10021AA;
        Thu, 17 Sep 2020 03:51:46 +0000 (UTC)
Date:   Thu, 17 Sep 2020 12:05:47 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 0/3] src/feature: add IO_URING feature checking
Message-ID: <20200917040546.GO2937@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: fstests@vger.kernel.org, io-uring@vger.kernel.org
References: <20200916122327.398-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916122327.398-1-zlang@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 16, 2020 at 08:23:24PM +0800, Zorro Lang wrote:
> This patchset bases on https://patchwork.kernel.org/cover/11769847/, which
> makes xfstests fsstress and fsx supports IO_URING.
> 
> The io_uring IOs in fsstress will be run automatically when fsstress get
> running. But fsx need a special option '-U' to run IO_URING read/write, so
> add two new cases to xfstests to do fsx buffered and direct IO IO_URING
> test.
> 
> [1/3] new helper to require io_uring feature
> [2/3] fsx buffered IO io_uring test
> [3/3] fsx direct IO io_uring test
> 
> And the [2/3] just found an io_uring regression bug (need LVM TEST_DEV):
> https://bugzilla.kernel.org/show_bug.cgi?id=209243
> 
> Feel free to tell me, if you have more suggestions to test io_uring on
> filesystem.
> 
> Thanks,
> Zorro

Err... Sorry about 3 duplicate patchset. I tried to sent this patchset 3 times
yesterday, but all failed, and I got feedback from server:
  "The message you sent to fstests@vger.kernel.org hasn't been delivered yet due to: Communications error."

I thought these emails have been abandoned, never know they're delayed. Please
only review the last patchset of these duplicate things.

Thanks,
Zorro

> 

