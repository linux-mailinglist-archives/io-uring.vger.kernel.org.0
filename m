Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736C96A1932
	for <lists+io-uring@lfdr.de>; Fri, 24 Feb 2023 10:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjBXJz0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Feb 2023 04:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjBXJz0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Feb 2023 04:55:26 -0500
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3792FCC3;
        Fri, 24 Feb 2023 01:55:24 -0800 (PST)
Received: by mail-wr1-f47.google.com with SMTP id h14so4639367wru.4;
        Fri, 24 Feb 2023 01:55:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5hKOP+zOtwvtwGqPgrZA/GUj5RgMDSUC85g3TVd1JRk=;
        b=q7gBLyjT05lmDfqKGCGDsXl1X+d/Jgbq4PE/lZDDI+sRlwqoDb8LEPtZBnVIzMXJxs
         1A5JBxNjfcISYTSX0QaUf6qWqXtFter8Zo7UygmCEKYmDThWPRN4rv6yqaMq+YD0aUD6
         0UW8XN1IR8J38sMQL5i7dYzkXwyKk+kbdBYYOTYvCRiJPFrFQaj5/WvNktsGTj+URP+V
         QNA835coK0kSuv7XLSAJAje98LSv1R4o+pmJFb2ZGsZ8hOdMJ+9DLF2ySbemxhAf1/o1
         Gt5zVlUC+sgey3VEibvs6EJbZnEe9tbTAaxgYKrljXmxnOykVlI/ot106a4IyjWrmKBd
         H7UA==
X-Gm-Message-State: AO0yUKU1rXAW7slnwYSsHqocmYsS+01luIO7BUekMkk4u/Yq9aql3Ivc
        VSp0NZHqsnpn5DSS3lHHTg4=
X-Google-Smtp-Source: AK7set+e91vux3xxQR5qvOrgh0yokPiZgUQyPmdVxgud4LEV9Q76tpnJP6QeS8K/jsATllGhi+GWJg==
X-Received: by 2002:adf:fe87:0:b0:2c5:54a7:363e with SMTP id l7-20020adffe87000000b002c554a7363emr14515575wrr.3.1677232522615;
        Fri, 24 Feb 2023 01:55:22 -0800 (PST)
Received: from gmail.com (fwdproxy-cln-022.fbsv.net. [2a03:2880:31ff:16::face:b00c])
        by smtp.gmail.com with ESMTPSA id j8-20020a5d6048000000b002c553e061fdsm15114349wrt.112.2023.02.24.01.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 01:55:22 -0800 (PST)
Date:   Fri, 24 Feb 2023 01:55:20 -0800
From:   Breno Leitao <leitao@debian.org>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 1/2] io_uring: Move from hlist to io_wq_work_node
Message-ID: <Y/iJiCW+HmWZofgs@gmail.com>
References: <20230223164353.2839177-1-leitao@debian.org>
 <20230223164353.2839177-2-leitao@debian.org>
 <87wn48ryri.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wn48ryri.fsf@suse.de>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Krisman, thanks for the review

On Thu, Feb 23, 2023 at 04:02:25PM -0300, Gabriel Krisman Bertazi wrote:
> Breno Leitao <leitao@debian.org> writes:

> >  static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
> >  {
> > -	if (!hlist_empty(&cache->list)) {
> > -		struct hlist_node *node = cache->list.first;
> > +	if (cache->list.next) {
> > +		struct io_cache_entry *entry;
> >  
> > -		hlist_del(node);
> > -		return container_of(node, struct io_cache_entry, node);
> > +		entry = container_of(cache->list.next, struct io_cache_entry, node);
> > +		cache->list.next = cache->list.next->next;
> > +		return entry;
> >  	}
> 
> From a quick look, I think you could use wq_stack_extract() here

True, we can use wq_stack_extract() in this patch, but, we would need to
revert to back to this code in the next patch. Remember that
wq_stack_extract() touches the stack->next->next, which will be
poisoned, causing a KASAN warning.

Here is relevant part of the code:

	struct io_wq_work_node *wq_stack_extract(struct io_wq_work_node *stack)
	{
		struct io_wq_work_node *node = stack->next;
		stack->next = node->next;
