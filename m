Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07AD3065F4
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 22:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbhA0V0j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 16:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbhA0V00 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 16:26:26 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04588C061573
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 13:25:45 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id e19so2154147pfh.6
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 13:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vv994uv9DDeh8M5nXTMtpljk0eLKwZ6faW4D3T6Gc+I=;
        b=oHfUw+AGfUUeItet2VfpG8yyaLsWvzGsI21LsNPHCVH8BOd27P+cg6X8vydX+7zA80
         +Rqhd8MhDB1uQXG0sDPqjU4llq8UGEwb1nSMzO65/D5AuPHiwDFPK2Y0AU2aStAMMgsh
         s0DiG+UQA47jfU7LS81FQp+ie/PpvGg5SEilVbOaGU9f60T6WxCP9SJv7rDeuttTQJ4O
         WKL1qAdcq+99fVb9oLp3KyeKCOinPQv2uRzpyYP6ndmVMWv9mwhtFXOygHK7idYTipIc
         qs6LNcYyP6Qx5tlFpBvgD+G6RwFcmq4xChlwzJhYyb6l4z6C8A27xwGDXo8mXJNiWWGM
         BUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vv994uv9DDeh8M5nXTMtpljk0eLKwZ6faW4D3T6Gc+I=;
        b=YdSYAjvyDQD+P/qzmuCwIU75EW3Ufm1XsL78Ubh/5OMHeCrtjz+tz1kaLgIhqac3Le
         AjW25HTozyfJMaERRw5W+1vImbMMsNNPLLyGGlcQpzHLfFVotEnB4YZUbNBkBKKvickV
         IJMDc54SXdr9f2pbRds8UEVXBFbTj3VLRy7v6SjS9Ta8wM20qJG0hSZZaBdwdyCbWdfT
         FBFxfqZwOAnaAGp1Ok72xp0i7DkQ6iaqEzD0OQKSAfNjWWH/1xlGO/8Rkcv92pCVmfFo
         S4Kt2ocwW1cYaxuybCaSqGxVdKmqoWpAzlLTQ+S7gfCCl1mkZs+VOt3+aATUelPdLD4z
         mfAQ==
X-Gm-Message-State: AOAM533m+9L9CWUnQ4F0w6v/KMrg2dgJCtl2RcTSRcsvNeATdvavzKpD
        CmOMNCmB3flS6VbnyeYYbsxKmy8SVcb58Q==
X-Google-Smtp-Source: ABdhPJxfLKFqXMV47Y75VjzgYdzFoy54EEwOKZ8ubuP+ellaVxRbtsLLHwsO2XoLYMJkF7bZCtbgvg==
X-Received: by 2002:a63:1707:: with SMTP id x7mr12949067pgl.266.1611782745238;
        Wed, 27 Jan 2021 13:25:45 -0800 (PST)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id mm4sm2794349pjb.1.2021.01.27.13.25.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 13:25:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/5] file_operations based io_uring commands
Date:   Wed, 27 Jan 2021 14:25:36 -0700
Message-Id: <20210127212541.88944-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This is a concept I've been toying with, some (including myself) have
referred to it as a way to do ioctls over io_uring. And indeed it has
many similarities with that. The purpose of the patchset is to have
a file private command type. io_uring doesn't know or care what is in
it, only the end target would be able to do that. In that sense it's
similar to ioctls which share the same trait. io_uring just provides
all the infrastructure to pass them back and forth, etc.

At the core of it, we overlay a struct type on top of io_uring_sqe.
That's basically like other commands, except this one is a bit more
brutal. That leaves us with 32 bytes that we can use, 8 bytes that
we can't (as they overlap with ->user_data), and then 8 bytes that are
usable again. Hence there's 40 bytes available for a command, anything
more than that should be allocated as per usual for request types.

The file_operations structure is augmented to add a ->uring_cmd()
handler. A file type must support this operation to support these
kinds of commands, otherwise they get errored. This handler can
either queue this operation async and signal completion when done,
or it can complete it inline (either successfully, or in error).

Proof of concept added for raw block and network commands, just to
show how it could work. Nothing exciting/interesting yet, just a
way to test it out.

This is very much sent out for comments/review of the concept itself.
There are a host of things that could be implemented with this, like
raw device access, new APIs (network zero copy additions), etc.

I'm not a huge fan of the command overlay, but I do like the fact that
we can do alloc less commands as long as we stay at <= 40 bytes. So
maybe it's just a pill that we have to swallow. Or maybe there are
other great ideas for how to do this. It does mean that we overlay
much of the sqe, but most of that won't make sense for private commands.

Anyways, comments welcome. This is kept on io_uring for now until
details have been hashed out.

-- 
Jens Axboe



