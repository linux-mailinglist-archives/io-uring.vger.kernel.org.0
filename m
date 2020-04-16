Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164B21AD107
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2020 22:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgDPUYd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Apr 2020 16:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727870AbgDPUYc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Apr 2020 16:24:32 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC79C061A0C
        for <io-uring@vger.kernel.org>; Thu, 16 Apr 2020 13:24:32 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d1so2204328pfh.1
        for <io-uring@vger.kernel.org>; Thu, 16 Apr 2020 13:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=L/n//1NmrLQ1rB/c+T8cyIBLIYd+wdsWBh4x6dpDLmg=;
        b=NznW0Yym/ViUK7KoRkJKFIX4HlTG44CtSpVYVFDwFJXFuZGNMfqNd65HMS61ADn2gn
         NOmH2SOMv5UNoL+L30AInPJX2g0TYIYIk3ouVs0+F+Tw/gsuX39Nt02p7qizVSiUWyOG
         dzgn47Y9Hb2q6RoUYSwsT6LJYGMTeuRurfKK0JmGL84L3Uxf7EArabBUQkOyU/wrA97v
         nQtrGkaZhT4H/FkVe5MncPL5fBWPHJfpfwoylCrekt2A/VV29PGiuqdEIln8++7rUC4t
         4XxXEoxo8jA07Q401VBuwLWSpOl+Irl7jnFJQOWAgH9DFScXae5GrnYfwqo4UO8P+RAY
         p+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=L/n//1NmrLQ1rB/c+T8cyIBLIYd+wdsWBh4x6dpDLmg=;
        b=Ghic/WWn40o9snKXL4/rS4GGr1ruB97abaUVfunfJ1n2KMmr6iHBsJDBFM6HtJagVA
         2F23hh6RzreSVwkyTpN9+ScUndLi4GaEyYFdSAvzuYuPQCGaJa348Fsdrob/Tj0z9qLm
         sjyHQo1J+/2+7VBtvhcU5m3TtUp8q+HIG/yn6GptQ/DyBDVCYN6AwZ08MSSWlj8EP+np
         7NwPgJ6nDhiWBiclvrdQ8BNm6M9MpjL0PJRgPVptuMMQ8Bm2JDAsuu9X6h6YFPP0W1fB
         Zglz1OtZBw5y/1wsE2s7XZN+O1WCeMbWwwqZ3PXBqoEDm+drikJejF9vweSLxdxnj3BU
         BC6w==
X-Gm-Message-State: AGi0PubpYlRnNnucFcauFD71iQtyBNRELfkrlYD6tg3sBh/KLKs0G3ho
        8amQZ7GrNLTnACrnFKnIxdfdIQIU
X-Google-Smtp-Source: APiQypITN3Vvlbatn2c4hk0jf1DTsSjedUyXpxHdrDXNUCjCYy3rcXPMu0QOahw2MIBXmDDzyze3Og==
X-Received: by 2002:a62:76c1:: with SMTP id r184mr8211740pfc.155.1587068671651;
        Thu, 16 Apr 2020 13:24:31 -0700 (PDT)
Received: from google.com ([2601:647:4001:3000::50e3])
        by smtp.gmail.com with ESMTPSA id b4sm7496125pff.6.2020.04.16.13.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 13:24:29 -0700 (PDT)
Date:   Thu, 16 Apr 2020 13:24:28 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [RFC 1/1] io_uring: preserve work->mm since actual work
 processing may need it
Message-ID: <20200416202428.GA50092@google.com>
References: <1586469817-59280-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1586469817-59280-2-git-send-email-bijan.mottahedeh@oracle.com>
 <f38056cf-b240-7494-d23b-c663867451cf@gmail.com>
 <465d7f4f-e0a4-9518-7b0c-fe908e317720@oracle.com>
 <dbcf7351-aba2-a64e-ecd9-26666b30469f@gmail.com>
 <e8ca3475-5372-3f99-ff95-c383d3599552@oracle.com>
 <46e5b8bf-0f14-caff-f706-91794191e730@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46e5b8bf-0f14-caff-f706-91794191e730@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

Sorry for the late.

On Fri, Apr 10, 2020 at 08:17:29PM -0600, Jens Axboe wrote:
> On 4/10/20 12:09 PM, Bijan Mottahedeh wrote:
> > On 4/10/2020 10:51 AM, Pavel Begunkov wrote:
> >> On 10/04/2020 19:54, Bijan Mottahedeh wrote:
> >>>> As I see, this down_read() from the trace is
> >>>> down_read(&current->mm->mmap_sem), where current->mm is set by use_mm()
> >>>> just several lines above your change. So, what do you mean by passing? I
> >>>> don't see do_madvise() __explicitly__ accepting mm as an argument.
> >>> I think the sequence is:
> >>>
> >>> io_madvise()
> >>> -> do_madvise(NULL, req->work.mm, ma->addr, ma->len, ma->advice)
> >>>                      ^^^^^^^^^^^^
> >>>     -> down_read(&mm->mmap_sem)
> >>>
> >>> I added an assert in do_madvise() for a NULL mm value and hit it running the test.
> >>>
> >>>> What tree do you use? Extra patches on top?
> >>> I'm using next-20200409 with no patches.
> >> I see, it came from 676a179 ("mm: pass task and mm to do_madvise"), which isn't
> >> in Jen's tree.
> >>
> >> I don't think your patch will do, because it changes mm refcounting with extra
> >> mmdrop() in io_req_work_drop_env(). That's assuming it worked well before.
> >>
> >> Better fix then is to make it ```do_madvise(NULL, current->mm, ...)```
> >> as it actually was at some point in the mentioned patch (v5).
> >>
> > Ok. Jens had suggested to use req->work.mm in the patch comments so 
> > let's just get him to confirm:
> > 
> > "I think we want to use req->work.mm here - it'll be the same as
> > current->mm at this point, but it makes it clear that we're using a
> > grabbed mm."
> 
> We should just use current->mm, as that matches at that point anyway
> since IORING_OP_MADVISE had needs_mm set.
> 
> Minchan, can you please make that change?

Do you mean this?

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a9537cd77aeb..3edbb4764993 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3280,7 +3280,7 @@ static int io_madvise(struct io_kiocb *req, bool force_nonblock)
        if (force_nonblock)
                return -EAGAIN;

-       ret = do_madvise(NULL, req->work.mm, ma->addr, ma->len, ma->advice);
+       ret = do_madvise(NULL, current->mm, ma->addr, ma->len, ma->advice);
        if (ret < 0)
                req_set_fail_links(req);
        io_cqring_add_event(req, ret);

Since I have a plan to resend whole patchset again, I will carry on
that.

