Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1703A5F7C48
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 19:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJGRfL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Oct 2022 13:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJGRfK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 13:35:10 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8395742E78
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 10:35:09 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id g130so6249135oia.13
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 10:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dk6tQJdYrdVnt5J0XTqD1Ykt5Zifw0rjbpHHEmz3lLs=;
        b=GMO4QHCYRB7uW89yNSgBKu6So0atvk7I30X3cih57CLaErtXYhsr8vnxtQWwL55U0T
         u94Axl9dsJMl0J6xnuCJaCsc50hud9rOR4EWTE4kguwkaFySGG9XyrrUE/LP5e2aLBhW
         XcR6E/8yzPbF8LSsulYQJFXrGiAPIHNT1BmzVkOBzj8AJp33/0blQPBamAw4RNwELvbR
         bOpyrb4ga/h/VtXBpTFBFwQdLFw5jvoL6GmX69coKW8W+DTVNH3aa0y+S8UJ3iN3cIHZ
         Xlp0cOjSFVkx+fmhwO5CnzYAl/TaeZmGdWATulskMeLyO8b55VWIWlFYq33pTsCq2lMo
         pgvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dk6tQJdYrdVnt5J0XTqD1Ykt5Zifw0rjbpHHEmz3lLs=;
        b=to78Cl7GydyU/OcAVv6MiUGwFNkLLEg4j/ogsbsAxixVPbJVhX4LaAExquXNi9VNHr
         DRseq5D2QZfRMFl5x7e4m75KLLqG4leIUDztzOu37UkKIM0m8JOMmG6mlUUSCcrVvexh
         wQBVJoVu86UfgegGr5UD/A/YYnMjzQdCihGE6BYbhBF4OZ5SlssObIWrZtr0PiVI8oPr
         zLCabgUB8vxRwcymuqtKSPDhEu+oPnU7tN+lIXZ34YZORystvJNQV8ve0HJrPsJtnXdc
         t4NeoqIa0BZrm1cUc+dqTrc/4eo9K0e2FnDy7+AA7BCL7/TZjXwmeNEjXExUayQvaoCv
         bhNQ==
X-Gm-Message-State: ACrzQf38MHBm1BgAdNzlLd6xuxaBK1LDqoa+r27BIHCkbAfNEAf5Muvz
        34eeifZL5ubVrK3VgYr/K0m5g7ZREcjIZ7lmAzxy
X-Google-Smtp-Source: AMsMyM6HOob3OhYe+iDodY/fdaWV2GZRIkRuW67saGDP2dd9w/7MHUwV1/LY76uwHOehBToBbFtWYduOjNB4W270Dzw=
X-Received: by 2002:a05:6808:144b:b0:350:a06a:f8cb with SMTP id
 x11-20020a056808144b00b00350a06af8cbmr8293565oiv.51.1665164108830; Fri, 07
 Oct 2022 10:35:08 -0700 (PDT)
MIME-Version: 1.0
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 7 Oct 2022 13:34:58 -0400
Message-ID: <CAHC9VhSzQtFkksJ5zBnhOYCpvDGNjjn7SKoC4MmopepWzb+Hfg@mail.gmail.com>
Subject: IORING_OP_SENDMSG_ZC should enable auditing just like IORING_OP_SENDMSG
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Commit 493108d95f14 ("io_uring/net: zerocopy sendmsg") added a new
zerocopy sendmsg command to io_uring, but it enabled the
io_op_def:audit_skip flag, causing the operation to bypass auditing.
As far as I can see, the SENDMSG_ZC operation should be subject to
auditing just as SENDMSG.

-- 
paul-moore.com
