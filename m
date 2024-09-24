Return-Path: <io-uring+bounces-3280-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDBA198425B
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 11:39:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A729EB2A331
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 09:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB3F215665E;
	Tue, 24 Sep 2024 09:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MJzgyhDH"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB2F16C69F
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 09:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727170378; cv=none; b=XHyscMrbxekAv156qx49quBuLa2r67IQZTw9g47V0/3cTsa2HZIqpbMjzSTOGeIr1hHyEi/pvUdsaD4yleQ1MXEyR3XVR3SW/yDZtASDP2YEDhVy9GYebehhlhkVP3Lt0n2dEwPmb8hhb8zPWikTm+qWKujh9MWg0zuZmTdhpfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727170378; c=relaxed/simple;
	bh=V+ELe4E9uFwQj054r/Jcsucbfc6XQECq5yTeJrKQLHY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=BQOdHMKy9/qeT0BHxqhE2klVVCxeDzY+Ed2mR/QxlAyWIgEJuxQCy3RVZDt4B6rs1aein83KZVgDbUgo2XvWZccyA95vpra04XzpsYBTvi/pyDa01OD+DRMQNh2KvejqlP3+SLOQxKWmgA2mPcy4qso4A759UhFrhdb+VUMf0t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MJzgyhDH; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240924093254epoutp0368be28c3474b0cce8f82a87b27b43e35~4JE3_7RHH1498314983epoutp03C
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 09:32:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240924093254epoutp0368be28c3474b0cce8f82a87b27b43e35~4JE3_7RHH1498314983epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727170374;
	bh=a1KGesAELSjoM3CNHWSuA/w2qdN0GDb05W2HWZKd9+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJzgyhDH3dujQ+5nuC0yqsiqygR77xTkF5JSwNNfsj9SSKLLOoYxKC3wA+5r1w7Hr
	 GHXjrGdTnBk+OMlQx8dlN0mfOdLIwcTgT/5wxJ90j8a7ibaEp2T+lWAQ3t+hxG7V1u
	 7vkmbegqNbVUvLPcehuKnNxlBHI6CD2lhY4AlGpY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240924093253epcas5p4000a431179cb6770456b1a1f8230b95d~4JE24QMqd2460424604epcas5p4l;
	Tue, 24 Sep 2024 09:32:53 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XCZQq5FBRz4x9QF; Tue, 24 Sep
	2024 09:32:51 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7B.09.09743.34782F66; Tue, 24 Sep 2024 18:32:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240924093250epcas5p39259624b9ebabdef15081ea9bd663d41~4JE0lHa780853908539epcas5p3q;
	Tue, 24 Sep 2024 09:32:50 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240924093250epsmtrp25777f08766f9f1b36e8c56bd03731043~4JE0jMi3r1248212482epsmtrp2f;
	Tue, 24 Sep 2024 09:32:50 +0000 (GMT)
X-AuditID: b6c32a4a-14fff7000000260f-8b-66f287434632
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	ED.F8.19367.24782F66; Tue, 24 Sep 2024 18:32:50 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240924093247epsmtip23be9317c98dc82302e994aca33fafeee~4JExKsIiC0076200762epsmtip2d;
	Tue, 24 Sep 2024 09:32:47 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org, viro@zeniv.linux.org.uk,
	jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org, asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com, Kanchan
	Joshi <joshi.k@samsung.com>, Hui Qi <hui81.qi@samsung.com>, Nitesh Shetty
	<nj.shetty@samsung.com>
Subject: [PATCH v6 1/3] nvme: enable FDP support
Date: Tue, 24 Sep 2024 14:54:55 +0530
Message-Id: <20240924092457.7846-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240924092457.7846-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta1ATVxidu7vZDbTRbaBwZTqFZmwVGSBgwEsV32N3CtMJfVintkMDWR4C
	ScgmSGmnpvIooqBSSyVqYylaDeOLRzQglkEYRhGwoiIvyyPUGSivRGsZLDRhqfXfOd893/3u
	OXc+IS42UD7CZJWO1aoUqRLSnbBc918RuOVbe4K0rO4tdNxsAaii/yCJCuaqCTR23Q5QydQM
	jib2zhKou8GKobMVzRiynj5HoYncdgId+yEbQ7YLRhwN9zko1Dw/TqLixvsAHSnZC1B9TwC6
	Wn+DQKbTIxT6pWUOQ5ZZE47Oj00SqOOfFgHqMB6nNkKm824UYzX2U0zHw0sE09mmZyrN+0im
	0l5MMVXle5i6bgPJTI/0EMzktXskU1RtBsytk00U46h8nam0jWPyJZ+krEtiFUpW68eq4tXK
	ZFVipCTqg9gtsWHh0pDAkAi0RuKnUqSxkZKt0fLAbcmpzhAkfhmKVL2zJFdwnCR4/TqtWq9j
	/ZLUnC5SwmqUqRqZJohTpHF6VWKQitW9HSKVhoY5hZ+nJPX9VSHQ1IVmWvovkgYwvrIACIWQ
	lsH64ZcLgLtQTNcBaK5pAjyxA2hvLqOek/yOUbIAuC10/PFNxeKBFcCJfTkETxwAtt86Rbju
	JWl/ePs7vavuSedhMGegBHcRnG7GYP7fDxau8qCl8FnrVcKFCfpN2Js3C1zNInoNtJ97jZ/m
	C0vvPKVc2I1G0Hz33oJcRL8Cb5TaFjDu1GTXHMN5vckNzphW8ngrrBw+JeCxBxxtqaZ47AMd
	E/WLblLgwNAAweOv4JWqokX9Bmh49kDgeg7u9HKhNpgftQQWztowPjoRzM8T8+o34MPikcVO
	bzh4tHwRM/BynhXj49kPoLV3nDwEfI0vODC+4MD4/7STADeDZayGS0tkuTBNqIrd/fxf49Vp
	lWBhFVa9ewUMDkwFNQJMCBoBFOIST1Fx93SCWKRUfJHFatWxWn0qyzWCMGfCh3GfV+PVzl1S
	6WJDZBFSWXh4uCxidXiIxFs0lntCKaYTFTo2hWU1rPa/Pkzo5mPAGmKMl6kYGSk1JdRtUFn3
	/5jZi58IH898qjYtvWSOq1rq/bHp94t31uY2bHQvFUfu9HqUtvzgHqV0e9z29MPX3t+UfaTY
	mO5Fl1uiCz6UJ9wujE4WHm3fFfzz6JfJARODiBqs0Bun1r7TVlB6Rp7XMlIr9pyvMWXc/yjj
	SdJLvnObhWds0z8dcO9qNc3F7rI0ZimLPn1PH53uf3OIzHrct6nOBmuU3M7eX5+Q8se7a5sy
	djhWd3lkLptPH/otCvsaybiOrjFBAOd102tmW2FPT3GK9nufR1k7ss8ayg79iQmMkzk6jxUS
	S+o8HbU53ruj1dHWGbw+Lib/s7HB5fXn1dI+CcElKUJW4VpO8S/o4f8JkwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02RWUwTYRSF/WfGmaGxMhSUX1DQEglLrCIaf40xRmMY4gNIMHF5gApDi7SA
	LeAeKqBINS6UgFYQNAS1lcWqSNlEFIkIFtnCnqCgUQJaqAtWUIuY+Hbv+c655+HSuKCOcKGj
	YxM4RaxYJiR5RPlTofuqbekTUWvUFk+UqysHSD9wkUTqmQcEGn06AVD25ykcjadYCdRTZ8TQ
	HX0DhoxFxRQaP/2KQNdyUjE0XKrF0dv+SQo1/BojUWZ9F0BZ2SkA1fT6ouqaFwTKLxqh0K3G
	GQyVW/NxVDL6iUCm6cb5yKTNpbZCtr1jJ2vUDlCsafAewba3JLIGXQbJGiYyKfZ+YTJb1aMi
	WfNIL8F+qu0k2QsPdIBtLnhGsZMGN9YwPIYFL9zH2xzJyaKTOMXqLeE8af9X/fz4qrVHygfK
	SBUY81IDOxoy6+C7U3pKDXi0gHkEYP6XCuovcIapXd/nZkd4Z+b9nMkMYOXzQkwNaJpkvGGr
	JtGmOzFXMNh0+wlpW3DmNQZ/ZVgIW9qRWQN/vqyenQlmJew7YwW2MJ/ZACeKl/4tcIdX277N
	ltkxCOo6OgmbRfDHMq0Jtsl8xgG+uDo8ewX/Y099eA2/BBjtf0j7HyoAmA4s4uKVcok8It5P
	pBTLlYmxElFEnNwAZp/sE1IBikqnRfUAo0E9gDQudOJn9pijBPxI8dFjnCIuTJEo45T1wJUm
	hM58D1lGpICRiBO4GI6L5xT/KEbbuaiwsvNHyVpNnkP/w3NppqKgs81jy17q48Sugdt0Uuvr
	SOSSdLLUX+7ETJXmqlqc9PlNAUua7p7yzhlSOzsnE82jHuYllVtkWSPHVMtFXSKgM0p2Dx7U
	fFg2bGz3LbOvPO6wacWustZk+/GC3T36DNf2IV+DW4J7QNDGwJv700dPf1x/yHT8gHpqx+LW
	bklJWhD2LBl5g9sON+r2akP4QxsqwkJT3kYo+36+ibkeF/rDdF8b5hllXcAsCOt2qyp8bPay
	RCXM6+Mi2vyrLUO0NJs7k/tI03KE2d6xZ3NxXl5KaLQHr+ULlXbzcszh8EkcDc6z84aEdPr8
	ifW9Ost718tCQikV+/ngCqX4N9I1N29TAwAA
X-CMS-MailID: 20240924093250epcas5p39259624b9ebabdef15081ea9bd663d41
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240924093250epcas5p39259624b9ebabdef15081ea9bd663d41
References: <20240924092457.7846-1-joshi.k@samsung.com>
	<CGME20240924093250epcas5p39259624b9ebabdef15081ea9bd663d41@epcas5p3.samsung.com>

Flexible Data Placement (FDP), as ratified in TP 4146a, allows the host
to control the placement of logical blocks so as to reduce the SSD WAF.

Userspace can send the data lifetime information using the write hints.
The SCSI driver (sd) can already pass this information to the SCSI
devices. This patch does the same for NVMe.

Fetch the placement-identifiers if the device supports FDP.
The incoming write-hint is mapped to a placement-identifier, which in
turn is set in the DSPEC field of the write command.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Hui Qi <hui81.qi@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/nvme/host/core.c | 70 ++++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/nvme.h |  4 +++
 include/linux/nvme.h     | 19 +++++++++++
 3 files changed, 93 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ca9959a8fb9e..7fb3ed4fe9c0 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -44,6 +44,20 @@ struct nvme_ns_info {
 	bool is_removed;
 };
 
+struct nvme_fdp_ruh_status_desc {
+	u16 pid;
+	u16 ruhid;
+	u32 earutr;
+	u64 ruamw;
+	u8  rsvd16[16];
+};
+
+struct nvme_fdp_ruh_status {
+	u8  rsvd0[14];
+	__le16 nruhsd;
+	struct nvme_fdp_ruh_status_desc ruhsd[];
+};
+
 unsigned int admin_timeout = 60;
 module_param(admin_timeout, uint, 0644);
 MODULE_PARM_DESC(admin_timeout, "timeout in seconds for admin commands");
@@ -959,6 +973,19 @@ static bool nvme_valid_atomic_write(struct request *req)
 	return true;
 }
 
+static inline void nvme_assign_placement_id(struct nvme_ns *ns,
+					struct request *req,
+					struct nvme_command *cmd)
+{
+	enum rw_hint h = req->write_hint;
+
+	if (h >= ns->head->nr_plids)
+		return;
+
+	cmd->rw.control |= cpu_to_le16(NVME_RW_DTYPE_DPLCMT);
+	cmd->rw.dsmgmt |= cpu_to_le32(ns->head->plids[h] << 16);
+}
+
 static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 		struct request *req, struct nvme_command *cmnd,
 		enum nvme_opcode op)
@@ -1078,6 +1105,8 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req)
 		break;
 	case REQ_OP_WRITE:
 		ret = nvme_setup_rw(ns, req, cmd, nvme_cmd_write);
+		if (!ret && ns->head->nr_plids)
+			nvme_assign_placement_id(ns, req, cmd);
 		break;
 	case REQ_OP_ZONE_APPEND:
 		ret = nvme_setup_rw(ns, req, cmd, nvme_cmd_zone_append);
@@ -2114,6 +2143,40 @@ static int nvme_update_ns_info_generic(struct nvme_ns *ns,
 	return ret;
 }
 
+static int nvme_fetch_fdp_plids(struct nvme_ns *ns, u32 nsid)
+{
+	struct nvme_command c = {};
+	struct nvme_fdp_ruh_status *ruhs;
+	struct nvme_fdp_ruh_status_desc *ruhsd;
+	int size, ret, i;
+
+	size = struct_size(ruhs, ruhsd, NVME_MAX_PLIDS);
+	ruhs = kzalloc(size, GFP_KERNEL);
+	if (!ruhs)
+		return -ENOMEM;
+
+	c.imr.opcode = nvme_cmd_io_mgmt_recv;
+	c.imr.nsid = cpu_to_le32(nsid);
+	c.imr.mo = 0x1;
+	c.imr.numd =  cpu_to_le32((size >> 2) - 1);
+
+	ret = nvme_submit_sync_cmd(ns->queue, &c, ruhs, size);
+	if (ret)
+		goto out;
+
+	ns->head->nr_plids = le16_to_cpu(ruhs->nruhsd);
+	ns->head->nr_plids =
+		min_t(u16, ns->head->nr_plids, NVME_MAX_PLIDS);
+
+	for (i = 0; i < ns->head->nr_plids; i++) {
+		ruhsd = &ruhs->ruhsd[i];
+		ns->head->plids[i] = le16_to_cpu(ruhsd->pid);
+	}
+out:
+	kfree(ruhs);
+	return ret;
+}
+
 static int nvme_update_ns_info_block(struct nvme_ns *ns,
 		struct nvme_ns_info *info)
 {
@@ -2205,6 +2268,13 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
 		if (ret && !nvme_first_scan(ns->disk))
 			goto out;
 	}
+	if (ns->ctrl->ctratt & NVME_CTRL_ATTR_FDPS) {
+		ret = nvme_fetch_fdp_plids(ns, info->nsid);
+		if (ret)
+			dev_warn(ns->ctrl->device,
+				"FDP failure status:0x%x\n", ret);
+	}
+
 
 	ret = 0;
 out:
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 313a4f978a2c..a959a9859e8b 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -454,6 +454,8 @@ struct nvme_ns_ids {
 	u8	csi;
 };
 
+#define NVME_MAX_PLIDS   (WRITE_LIFE_EXTREME + 1)
+
 /*
  * Anchor structure for namespaces.  There is one for each namespace in a
  * NVMe subsystem that any of our controllers can see, and the namespace
@@ -490,6 +492,8 @@ struct nvme_ns_head {
 	struct device		cdev_device;
 
 	struct gendisk		*disk;
+	u16			nr_plids;
+	u16			plids[NVME_MAX_PLIDS];
 #ifdef CONFIG_NVME_MULTIPATH
 	struct bio_list		requeue_list;
 	spinlock_t		requeue_lock;
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index b58d9405d65e..a954eaee5b0f 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -275,6 +275,7 @@ enum nvme_ctrl_attr {
 	NVME_CTRL_ATTR_HID_128_BIT	= (1 << 0),
 	NVME_CTRL_ATTR_TBKAS		= (1 << 6),
 	NVME_CTRL_ATTR_ELBAS		= (1 << 15),
+	NVME_CTRL_ATTR_FDPS		= (1 << 19),
 };
 
 struct nvme_id_ctrl {
@@ -843,6 +844,7 @@ enum nvme_opcode {
 	nvme_cmd_resv_register	= 0x0d,
 	nvme_cmd_resv_report	= 0x0e,
 	nvme_cmd_resv_acquire	= 0x11,
+	nvme_cmd_io_mgmt_recv	= 0x12,
 	nvme_cmd_resv_release	= 0x15,
 	nvme_cmd_zone_mgmt_send	= 0x79,
 	nvme_cmd_zone_mgmt_recv	= 0x7a,
@@ -864,6 +866,7 @@ enum nvme_opcode {
 		nvme_opcode_name(nvme_cmd_resv_register),	\
 		nvme_opcode_name(nvme_cmd_resv_report),		\
 		nvme_opcode_name(nvme_cmd_resv_acquire),	\
+		nvme_opcode_name(nvme_cmd_io_mgmt_recv),	\
 		nvme_opcode_name(nvme_cmd_resv_release),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_send),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_recv),	\
@@ -1015,6 +1018,7 @@ enum {
 	NVME_RW_PRINFO_PRCHK_GUARD	= 1 << 12,
 	NVME_RW_PRINFO_PRACT		= 1 << 13,
 	NVME_RW_DTYPE_STREAMS		= 1 << 4,
+	NVME_RW_DTYPE_DPLCMT		= 2 << 4,
 	NVME_WZ_DEAC			= 1 << 9,
 };
 
@@ -1102,6 +1106,20 @@ struct nvme_zone_mgmt_recv_cmd {
 	__le32			cdw14[2];
 };
 
+struct nvme_io_mgmt_recv_cmd {
+	__u8			opcode;
+	__u8			flags;
+	__u16			command_id;
+	__le32			nsid;
+	__le64			rsvd2[2];
+	union nvme_data_ptr	dptr;
+	__u8			mo;
+	__u8			rsvd11;
+	__u16			mos;
+	__le32			numd;
+	__le32			cdw12[4];
+};
+
 enum {
 	NVME_ZRA_ZONE_REPORT		= 0,
 	NVME_ZRASF_ZONE_REPORT_ALL	= 0,
@@ -1822,6 +1840,7 @@ struct nvme_command {
 		struct nvmf_auth_receive_command auth_receive;
 		struct nvme_dbbuf dbbuf;
 		struct nvme_directive_cmd directive;
+		struct nvme_io_mgmt_recv_cmd imr;
 	};
 };
 
-- 
2.25.1


